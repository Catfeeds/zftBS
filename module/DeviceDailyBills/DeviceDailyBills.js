const fp = require('lodash/fp');
const _ = require('lodash');
const bigdecimal = require('bigdecimal');
const moment = require('moment');

function generateProject(projectId, time) {
    //
    return new Promise((resolve, reject)=>{

        const dailyFrom = moment(time).startOf('days').unix();
        const dailyTo = time.unix();

        const deviceFilter = {
            endDate: {$or:[
                {$eq: 0},
                {$between: [dailyFrom, dailyTo]}
            ]}
        };

        const AvgShare = (rooms)=>{
            const count = rooms.length;
            let base = Math.floor(100/count);
            let suffix = 0;
            if(base*count !==  100){
                suffix = 100 - base * count;
            }

            let share = {};
            let minTid = _.min(rooms);
            rooms.map(roomId=>{
                share[roomId] = base;
            });
            share[minTid] += suffix;
            return share;
        };

        MySQL.Contracts.findAll({
            where:{
                projectId: projectId,
                status:'ONGOING',
                from: {$lte: dailyFrom},
                to:{$ne: 0, $gte: dailyTo}
            },
            attributes:['id', 'roomId', 'userId'],
            include:[
                {
                    model: MySQL.Rooms,
                    as: 'room',
                    include:[
                        {
                            model: MySQL.HouseDevices,
                            as: 'devices',
                            where: deviceFilter
                        }
                    ],
                    required: false
                }
            ]
        }).then(
            contracts=>{
                if(!contracts.length){
                    return resolve();
                }

                const houseIds = _.compact( fp.map(contract=>{return contract.room && contract.room.houseId;})(contracts) );
                const roomId2ContractId = _.fromPairs(fp.map(contract=>{
                    return [contract.roomId, contract.id]
                })(contracts));

                let deviceIds = [];
                let houseId2Rooms = {};
                let deviceId2RoomId = {};
                let roomId2UserId = {};
                _.each(contracts, contract=>{
                    if(!contract.room){
                        return;
                    }
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
                });

                MySQL.Houses.findAll({
                    where:{
                        id: {$in: houseIds}
                    },
                    include:[
                        {
                            model: MySQL.HouseDevices,
                            as:'devices',
                            where:_.assignIn({
                                public: true
                            }, deviceFilter)
                        }
                    ]
                }).then(
                    houses=>{
                        let publicDeviceId2HouseId = {};
                        _.each(houses, house=>{
                            _.each(house.devices, device=>{
                                publicDeviceId2HouseId[device.deviceId] = house.id;
                                deviceIds.push(device.deviceId);
                            });
                        });

                        //
                        MySQL.HousesBillsFlows.findAll({
                            where:{
                                deviceId:{$in: deviceIds},
                                createdAt: time.format('YYYYMMDD')
                            }
                        }).then(
                            flows=>{
                                const Pay = (devicePrePaid, roomId)=>{
                                    log.info('device pre paid: ', devicePrePaid);
                                    const userId = roomId2UserId[roomId];

                                    Util.PayWithOwed(userId, devicePrePaid.amount).then(
                                        ret=>{
                                            if(ret.code !== ErrorCode.OK ){
                                                log.error('PayWithOwed failed', userId, devicePrePaid, roomId, ret);
                                                return;
                                            }

                                            MySQL.DevicePrePaid.create(devicePrePaid);
                                            Message.BalanceChange(projectId, userId, ret.amount, ret.balance);
                                        }
                                    );
                                };

                                _.each(flows, flow=>{
                                    const deviceId = flow.deviceId;
                                    if(publicDeviceId2HouseId[flow.deviceId]){
                                        //a public device
                                        const houseId = publicDeviceId2HouseId[flow.deviceId];
                                        const rooms = houseId2Rooms[houseId];
                                        const share = AvgShare(rooms);
                                        _.map(share, (rate, roomId)=>{

                                            let amount = new bigdecimal.BigDecimal(flow.amount.toString());
                                            const rateStr = new bigdecimal.BigDecimal(rate.toString());
                                            amount = amount.multiply(rateStr).doubleValue();

                                            const devicePrePaid = {
                                                type:'ELECTRICITY',
                                                contractId: roomId2ContractId[roomId],
                                                projectId: projectId,
                                                deviceId: flow.deviceId,
                                                amount: -amount,
                                                scale: flow.scale,
                                                usage: flow.usage,
                                                share: rate * 100,
                                                createdAt: moment().unix()
                                            };
                                            Pay(devicePrePaid, roomId);
                                        });
                                    }
                                    else{
                                        //
                                        const roomId = deviceId2RoomId[deviceId];
                                        const devicePrePaid = {
                                            type:'ELECTRICITY',
                                            contractId: roomId2ContractId[roomId],
                                            projectId: projectId,
                                            deviceId: flow.deviceId,
                                            amount: -flow.amount,
                                            scale: flow.scale,
                                            usage: flow.usage,
                                            createdAt: moment().unix()
                                        };
                                        Pay(devicePrePaid, roomId);
                                    }
                                });


                                //

                                resolve();
                            }
                        );
                    }
                );


            }
        );
    });
}

function generate(projects, time) {
    if(!projects.length){
        return log.warn('HousesBills Done...')
    }

    const next = ()=>{
        return setImmediate(()=>{
            generate(_.tail(projects));
        })
    };

    const project = _.head(projects);
    generateProject(project.id, time).then(
        ()=>{
            next();
        }
    );
}

exports.Run = ()=>{
    let lastPaymentTime;
    let tryPayment = function()
    {
        setTimeout(function(){
            setTimeout(function(){
                // let m = moment('2017 1227 0800', 'YYYY MMDD HHmm');
                let m = moment();
                let timePoint = m.format('HHmm');
                // log.info('check payment time: ', m.format('YYYY-MM-DD HH:mm:ss'));
                if(timePoint === '0800'){
                    //
                    if(!lastPaymentTime || lastPaymentTime.format('YYYYMMDD') !== m.format("YYYYMMDD")){
                        lastPaymentTime = moment(m);
                        m.subtract(1, 'day').endOf('day');

                        MySQL.Projects.findAll({}).then(
                            projects=>{
                                generate( projects, m );
                            }
                        );
                    }
                }
                tryPayment();
            }, 1000 * 60);
        }, 0);
    };
    tryPayment();
};

exports.ModuleName = 'DeviceDailyBills';