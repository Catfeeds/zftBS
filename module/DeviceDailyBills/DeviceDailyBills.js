const fp = require('lodash/fp');
const _ = require('lodash');
const bigdecimal = require('bigdecimal');
const moment = require('moment');

function generateProject(projectId, setting, time) {
    //
    return new Promise((resolve, reject)=>{

        const dailyFrom = moment(time).startOf('days').unix();
        const dailyTo = time.unix();

        const paymentDay = moment(time).unix();

        const deviceFilter = {
            endDate: {$or:[
                {$eq: 0},
                {$gte: dailyFrom}
            ]}
        };

        MySQL.Contracts.findAll({
            where:{
                projectId: projectId,
                status:'ONGOING',
                // from: {$lte: dailyFrom},
                // to:{$ne: 0, $gte: dailyTo}
            },
            attributes:['id', 'roomId', 'userId', 'expenses'],
            include:[
                {
                    model: MySQL.Rooms,
                    as: 'room',
                    include:[
                        {
                            model: MySQL.HouseDevices,
                            as: 'devices',
                            where: deviceFilter,
                            required: true,
                        }
                    ],
                    required: true
                }
            ]
        }).then(
            contracts=>{
                if(!contracts.length){
                    log.info(projectId, ' contracts is empty ');
                    return resolve();
                }

                const houseIds = _.compact( fp.map(contract=>{return contract.room && contract.room.houseId;})(contracts) );
                const roomId2ContractId = _.fromPairs(fp.map(contract=>{
                    return [contract.roomId, contract.id];
                })(contracts));
                const payDevice = (devicePrePaid, roomId)=>{
                    const userId = roomId2UserId[roomId];

                    const flowId = Util.newId();
                    const prePaidObj = _.assign(devicePrePaid, {id: Util.newId(), flowId: flowId});

                    const prePaidFlow = {
                        id: flowId,
                        projectId: projectId,
                        contractId: devicePrePaid.contractId,
                        paymentDay: devicePrePaid.paymentDay,
                        category: 'device'
                    };

                    log.info('devicePrePaid: ', userId, prePaidObj, prePaidFlow);

                    Util.PayWithOwed(userId, devicePrePaid.amount).then(
                        ret=>{
                            if(ret.code !== ErrorCode.OK ){
                                log.error('PayWithOwed failed', userId, devicePrePaid, roomId, ret);
                                return;
                            }

                            MySQL.DevicePrePaid.create(devicePrePaid);
                            MySQL.PrePaidFlows.create(prePaidFlow);
                            Message.BalanceChange(projectId, userId, ret.amount, ret.balance);
                        }
                    );
                };
                const payDaily = (daily)=>{
                    const flowId = Util.newId();
                    const createDaily = _.assign(daily, {id: Util.newId(), flowId: flowId});
                    const prePaidFlow = {
                        id: flowId,
                        projectId: projectId,
                        contractId: daily.contractId,
                        paymentDay: daily.paymentDay,
                        category: 'device'
                    };
                    log.info('dailyPrePaid: ', daily.userId, createDaily, prePaidFlow);

                    Util.PayWithOwed(daily.userId, daily.amount).then(
                        ret=>{
                            if(ret.code !== ErrorCode.OK ){
                                log.error('PayWithOwed failed', daily);
                                return;
                            }

                            MySQL.DailyPrePaid.create(daily);
                            MySQL.PrePaidFlows.create(prePaidFlow);
                            Message.BalanceChange(projectId, daily.userId, ret.amount, ret.balance);
                        }
                    );
                };

                let deviceIds = [];
                let houseId2Rooms = {};
                let deviceId2RoomId = {};
                let roomId2UserId = {};
                let roomDevicePrice = {};
                let dailyPrePaid = [];
                _.each(contracts, contract=>{
                    if(!contract.room){
                        return;
                    }

                    //todo: 是否合同生效当天就进行计费

                    const roomId = contract.room.id;
                    const houseId = contract.room.houseId;

                    if(!houseId2Rooms[houseId]){
                        houseId2Rooms[houseId] = [];
                    }
                    houseId2Rooms[houseId].push(roomId);
                    roomId2UserId[contract.roomId] = contract.userId;

                    _.each(contract.room.devices, device=>{
                        deviceId2RoomId[device.deviceId] = contract.roomId;
                        deviceIds.push(device.deviceId);
                    });

                    //解析expenses中的预付费信息
                    _.each(contract.expenses, expense=>{
                        if(!expense.configId || expense.pattern !== 'prepaid'){
                            return;
                        }

                        //每日扣费
                        if(expense.frequency === 'day'){
                            dailyPrePaid.push({
                                roomId: contract.roomId,
                                userId: contract.userId,
                                configId: expense.configId,
                                contractId: contract.id,
                                projectId: projectId,
                                configName: expense.configId,
                                paymentDay: paymentDay,
                                amount: expense.rent,
                                createdAt: moment().unix()
                            });
                        }
                        else{
                            //如果合同中有单价，则优先使用合同中的单价
                            switch(expense.configId){
                            case 1041:
                                {
                                    //electric
                                    if(!roomDevicePrice[roomId]){ roomDevicePrice[roomId] = {};}

                                    roomDevicePrice[roomId].ELECTRIC = expense.rent;
                                }
                                break;
                            case 1043:
                                {
                                    //water
                                    if(!roomDevicePrice[roomId]){ roomDevicePrice[roomId] = {};}

                                    roomDevicePrice[roomId].WATER = expense.rent;
                                }
                                break;
                            }
                        }
                    });
                });

                Promise.all([
                    Util.getHouses(projectId, time, 'CLIENT', houseIds),
                    MySQL.HouseApportionment.findAll({
                        where:{
                            houseId: {$in: houseIds}
                        }
                    })
                ]).then(
                    result=>{
                        const houses = result[0];

                        let houseApportionment = {};
                        _.each(result[1], apportionment=>{
                            if(!houseApportionment[apportionment.houseId]){
                                houseApportionment[apportionment.houseId] = {};
                            }

                            houseApportionment[apportionment.houseId][apportionment.roomId] = apportionment.value;
                        });

                        const getAmountAndPrice = (cost)=>{
                            const roomId = deviceId2RoomId[cost.deviceId];
                            if(!roomDevicePrice[roomId]){
                                return {
                                    amount: cost.amount,
                                    price: cost.price
                                };
                            }
                            else{
                                const price = roomDevicePrice[roomId].ELECTRIC;
                                const amount = (new bigdecimal.BigDecimal(cost.usage.toString()))
                                    .multiply( new bigdecimal.BigDecimal(price.toString()) )
                                    .divide( new bigdecimal.BigDecimal('10000'), 0, bigdecimal.RoundingMode.DOWN() ).intValue();
                                return {
                                    amount: amount,
                                    price: price
                                };
                            }
                        };
                        const getApportionment = (houseId)=>{
                            const apportionment = houseApportionment[houseId];
                            if(!apportionment){
                                return Util.autoApportionment(houseId2Rooms[houseId]);
                            }
                            else{
                                return apportionment;
                            }
                        };

                        Util.dailyDeviceData(houses, time).then(
                            houseCostMapping=>{
                                _.each(houseCostMapping, costs=>{
                                    _.each(costs, cost=>{
                                        //
                                        const amountAndPrice = getAmountAndPrice(cost);
                                        const roomId = deviceId2RoomId[cost.deviceId];

                                        if(cost.public){
                                            //公区表
                                            const apportionment = getApportionment(cost.houseId);
                                            _.map(apportionment, (percent, roomId)=>{
                                                const amountOfShare = (
                                                    new bigdecimal.BigDecimal(amountAndPrice.amount.toString())
                                                ).multiply(new bigdecimal.BigDecimal(percent.toString())
                                                ).divide(new bigdecimal.BigDecimal('100'), 0, bigdecimal.RoundingMode.HALF_UP()).intValue();
                                                const devicePrePaid = {
                                                    type: 'ELECTRICITY',
                                                    contractId: roomId2ContractId[roomId],
                                                    projectId: projectId,
                                                    deviceId: cost.deviceId,
                                                    amount: -amountOfShare,
                                                    scale: cost.scale,
                                                    usage: cost.usage,
                                                    price: amountAndPrice.price,
                                                    share: percent,
                                                    paymentDay: paymentDay,
                                                    createdAt: moment().unix()
                                                };
                                                payDevice(devicePrePaid, roomId);
                                            });
                                        }
                                        else{
                                            //私有表
                                            const devicePrePaid = {
                                                type:'ELECTRICITY',
                                                contractId: roomId2ContractId[roomId],
                                                projectId: projectId,
                                                deviceId: cost.deviceId,
                                                amount: -amountAndPrice.amount,
                                                scale: cost.scale,
                                                usage: cost.usage,
                                                price: amountAndPrice.price,
                                                paymentDay: paymentDay,
                                                createdAt: moment().unix()
                                            };
                                            payDevice(devicePrePaid, roomId);
                                        }

                                    });
                                });

                                //do daily prepaid
                                log.info(dailyPrePaid);
                                _.each(dailyPrePaid, daily=>{
                                    payDaily(daily);
                                });

                                resolve();
                            },
                            err=>{
                                log.error(err, houses, time);
                            }
                        );
                    }
                    , err=>{
                        log.error(err, projectId, time, houseIds);
                    }
                );
            }
        );
    });
}

function generate(projects, setting, time) {
    if(!projects.length){
        return log.warn('HousesBills Done...');
    }

    const next = ()=>{
        return setImmediate(()=>{
            generate(_.tail(projects), setting, time);
        });
    };

    const project = _.head(projects);
    generateProject(project.id, setting, time).then(
        ()=>{
            next();
        }
    );
}

function batchBill() {
    const timeFrom = moment('2017 0701 0100', 'YYYY MMDD HHmm');
    // const timeTo = moment('2018 0220 0100', 'YYYY MMDD HHmm');
    const timeTo = moment('2017 1231 0100', 'YYYY MMDD HHmm');

    Promise.all([
        MySQL.Settings.findAll({}),
        MySQL.Projects.findAll({})
    ]).then(
        result=>{
            const setting = _.fromPairs(fp.map(setting=>{
                return [setting.id, setting];
            })(result[0]));

            // generate( result[1], setting, m );
            
            const doBill = (timeIndex)=>{
                if(timeIndex.unix() > timeTo.unix()){
                    return log.warn('done...');
                }

                const nextTime = ()=>{
                    return setImmediate(()=>{
                        doBill(timeIndex.add(1, 'days'));
                    });
                };
                const projectsBill = (projects)=>{
                    if(!projects.length){
                        log.info('done ', timeIndex.format('YYYYMMDD'));
                        return nextTime();
                    }

                    const next = ()=>{
                        return setImmediate(()=>{
                            projectsBill(_.tail(projects));
                        });
                    };

                    const project = _.head(projects);
                    generateProject(project.id, setting, timeIndex).then(
                        ()=>{
                            log.info(project.name, 'done');
                            next();
                        }
                    );
                };

                log.info('doing ', timeIndex.format('YYYYMMDD'));
                projectsBill(result[1]);
            };

            doBill(timeFrom);
        }
    );
}

exports.Run = ()=>{
    let lastPaymentTime;
    let tryPayment = function()
    {
        setTimeout(function(){
            setTimeout(function(){
                // let m = moment('2018 0428 0800', 'YYYY MMDD HHmm');
                let m = moment();
                let timePoint = m.format('HHmm');
                // log.info('check payment time: ', m.format('YYYY-MM-DD HH:mm:ss'));
                if(timePoint === '0800'){
                    //
                    if(!lastPaymentTime || lastPaymentTime.format('YYYYMMDD') !== m.format('YYYYMMDD')){
                        lastPaymentTime = moment(m);
                        m.subtract(1, 'day').endOf('day');

                        Promise.all([
                            MySQL.Settings.findAll({}),
                            MySQL.Projects.findAll({})
                        ]).then(
                            result=>{
                                const setting = _.fromPairs(fp.map(setting=>{
                                    return [setting.id, setting];
                                })(result[0]));

                                generate( result[1], setting, m );
                            }
                        );
                    }
                }
                tryPayment();
            }, 1000 * 60);
        }, 0);
    };
    tryPayment();
    // batchBill();
};

exports.ModuleName = 'DeviceDailyBills';