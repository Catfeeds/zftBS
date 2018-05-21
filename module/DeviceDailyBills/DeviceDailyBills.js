const fp = require('lodash/fp');
const bigdecimal = require('bigdecimal');
const moment = require('moment');
const schedule = require('node-schedule');
const {formatMysqlDateTime} = Include('/libs/util');

function calcShare(amountAndPrice, percent) {
    return (
        new bigdecimal.BigDecimal(
            amountAndPrice.amount.toString())
    ).multiply(
        new bigdecimal.BigDecimal(
            percent.toString()),
    ).
        divide(
            new bigdecimal.BigDecimal(
                '100'), 0,
            bigdecimal.RoundingMode.HALF_UP()).
        intValue();
}

const generateProject = (setting, dailyTo) => async projectId => {
    const dailyFrom = moment(dailyTo).startOf('days').unix();
    const paymentDay = moment(dailyTo).unix();

    return allContracts(MySQL)(projectId, dailyFrom).then(
        contracts => {
            if (!contracts.length) {
                log.info(`no contracts in project ${projectId}`);
                return;
            }
            // console.log('contracts', fp.map(a => a.toJSON())(contracts));
            const houseIds = fp.compact(
                fp.map(fp.get('room.houseId'))(contracts));
            const roomId2ContractId = fp.fromPairs(
                fp.map(contract => [contract.roomId, contract.id])(contracts));
            // console.log('houseIds', houseIds);
            // console.log('roomId2ContractId', roomId2ContractId);
            const payDevice = (devicePrePaid, roomId) => {
                const userId = roomId2UserId[roomId];

                const flowId = Util.newId();
                const prePaidObj = fp.assign(devicePrePaid,
                    {id: Util.newId(), flowId: flowId});

                const prePaidFlow = {
                    id: flowId,
                    projectId: projectId,
                    contractId: devicePrePaid.contractId,
                    paymentDay: devicePrePaid.paymentDay,
                    category: 'device',
                };

                log.info('devicePrePaid: ', userId, prePaidObj,
                    prePaidFlow);

                return Util.PayWithOwed(userId, prePaidObj.amount).then(
                    ret => {
                        if (ret.code !== ErrorCode.OK) {
                            log.error('PayWithOwed failed', userId,
                                prePaidObj, roomId, ret);
                            return;
                        }

                        return Promise.all([
                            MySQL.DevicePrePaid.create(prePaidObj),
                            MySQL.PrePaidFlows.create(prePaidFlow)]).
                            then(() => Message.BalanceChange(projectId, userId,
                                ret.amount,
                                ret.balance));
                    },
                );
            };
            const payDaily = (daily) => {
                const flowId = Util.newId();
                const createDaily = fp.assign(daily,
                    {id: Util.newId(), flowId: flowId});
                const prePaidFlow = {
                    id: flowId,
                    projectId: projectId,
                    contractId: daily.contractId,
                    paymentDay: daily.paymentDay,
                    category: 'device',
                };
                log.info('dailyPrePaid: ', daily.userId, createDaily,
                    prePaidFlow);

                Util.PayWithOwed(daily.userId, daily.amount).then(
                    ret => {
                        if (ret.code !== ErrorCode.OK) {
                            log.error('PayWithOwed failed', daily);
                            return;
                        }

                        MySQL.DailyPrePaid.create(daily);
                        MySQL.PrePaidFlows.create(prePaidFlow);
                        Message.BalanceChange(projectId, daily.userId,
                            ret.amount, ret.balance);
                    },
                );
            };

            let deviceIds = [];
            let houseId2Rooms = {};
            let deviceId2RoomId = {};
            let roomId2UserId = {};
            let roomDevicePrice = {};
            let dailyPrePaid = [];
            fp.each(contract => {
                if (!contract.room) {
                    return;
                }

                //todo: 是否合同生效当天就进行计费

                const roomId = contract.room.id;
                const houseId = contract.room.houseId;

                if (!houseId2Rooms[houseId]) {
                    houseId2Rooms[houseId] = [];
                }
                houseId2Rooms[houseId].push(roomId);
                roomId2UserId[contract.roomId] = contract.userId;

                fp.each(device => {
                    deviceId2RoomId[device.deviceId] = contract.roomId;
                    deviceIds.push(device.deviceId);
                })(contract.room.devices);

                //解析expenses中的预付费信息
                fp.each(expense => {
                    if (!expense.configId ||
                        expense.pattern !== 'prepaid') {
                        return;
                    }

                    //每日扣费
                    if (expense.frequency === 'day') {
                        dailyPrePaid.push({
                            roomId: contract.roomId,
                            userId: contract.userId,
                            configId: expense.configId,
                            contractId: contract.id,
                            projectId: projectId,
                            configName: expense.configId,
                            paymentDay: paymentDay,
                            amount: expense.rent,
                            createdAt: moment().unix(),
                        });
                    }
                    else {
                        //如果合同中有单价，则优先使用合同中的单价
                        switch (expense.configId) {
                        case 1041: {
                            //electric
                            if (!roomDevicePrice[roomId]) {
                                roomDevicePrice[roomId] = {};
                            }

                            roomDevicePrice[roomId].ELECTRIC = expense.rent;
                        }
                            break;
                        case 1043: {
                            //water
                            if (!roomDevicePrice[roomId]) {
                                roomDevicePrice[roomId] = {};
                            }

                            roomDevicePrice[roomId].WATER = expense.rent;
                        }
                            break;
                        }
                    }
                })(contract.expenses);
            })(contracts);

            return Promise.all([
                Util.getHouses(projectId, dailyTo, 'CLIENT', houseIds),
                MySQL.HouseApportionment.findAll({
                    attributes: ['houseId', 'roomId', 'value'],
                    where: {
                        projectId,
                        houseId: {$in: houseIds},
                    },
                }),
            ]).then(
                ([houses, apportionments]) => {
                    const houseApportionment = fp.mapValues(
                        fp.pipe(fp.groupBy('roomId'),
                            fp.mapValues(fp.pipe(fp.head, fp.get('value')))))(
                        fp.groupBy('houseId')(
                            fp.map(a => a.toJSON())(apportionments)));
                    // console.log('houseApportionment', houseApportionment);
                    // console.log('houses', fp.map(a => a.toJSON())(houses));

                    const getAmountAndPrice = (cost) => {
                        const roomId = deviceId2RoomId[cost.deviceId];
                        if (!roomDevicePrice[roomId]) {
                            return costOfRoom(houses, cost);
                        }
                        else {
                            const price = roomDevicePrice[roomId].ELECTRIC;
                            const amount = amountOf(cost.endScale -
                                cost.startScale, price).intValue();
                            return {
                                amount: amount,
                                price: price,
                            };
                        }
                    };
                    const getApportionment = houseId => {
                        const apportionment = houseApportionment[houseId];
                        return apportionment ?
                            apportionment :
                            Util.autoApportionment(houseId2Rooms[houseId]);
                    };
                    // console.log('heartbeatInProject: ', dailyFrom,
                    //     dailyTo.unix(), projectId);
                    return heartbeatInProject(MySQL)(dailyFrom, dailyTo.unix(),
                        projectId).then(
                        houseCostMapping => {
                            // console.log('houseCostMapping', houseCostMapping);
                            fp.each(costs => {
                                fp.each(cost => {
                                    //
                                    const amountAndPrice = getAmountAndPrice(
                                        cost);
                                    const roomId = deviceId2RoomId[cost.deviceId];

                                    if (cost.public) {
                                        //公区表
                                        const apportionments = fp.toPairs(
                                            getApportionment(cost.houseId));
                                        fp.each(([roomId, percent]) => {
                                            const amountOfShare = calcShare(
                                                amountAndPrice, percent);
                                            const devicePrePaid = {
                                                type: 'ELECTRICITY',
                                                contractId: roomId2ContractId[roomId],
                                                projectId,
                                                deviceId: cost.deviceId,
                                                amount: -amountOfShare,
                                                scale: scaleOf(cost),
                                                usage: usageOf(cost),
                                                price: amountAndPrice.price,
                                                share: percent,
                                                paymentDay,
                                                createdAt: moment().unix(),
                                            };
                                            payDevice(devicePrePaid,
                                                roomId);
                                        })(apportionments);
                                    }
                                    else {
                                        //私有表
                                        const devicePrePaid = {
                                            type: 'ELECTRICITY',
                                            contractId: roomId2ContractId[roomId],
                                            projectId,
                                            deviceId: cost.deviceId,
                                            amount: -amountAndPrice.amount,
                                            scale: scaleOf(cost),
                                            usage: usageOf(cost),
                                            price: amountAndPrice.price,
                                            paymentDay,
                                            createdAt: moment().unix(),
                                        };
                                        payDevice(devicePrePaid, roomId);
                                    }

                                })(costs);
                            })(houseCostMapping);

                            //do daily prepaid
                            log.info('do daily prepaid: ', dailyPrePaid);
                            fp.each(payDaily)(dailyPrePaid);
                        },
                    );
                },
            );
        },
    ).catch(err => {
        log.error(
            `error ${err} in calculating: ${projectId} at time ${dailyTo}`);
    });
};

const generate = (settings, endTime) =>
    projects =>
        Promise.all(
            fp.map(fp.pipe(fp.get('id'), generateProject(settings, endTime)))(
                projects)).
            then(() => log.warn('DeviceDailyBills Done...'));

exports.bill = (endTime) => Promise.all([
    MySQL.Settings.findAll({}),
    MySQL.Projects.findAll({attributes: ['id']}),
]).then(([settingRecords, projects]) => {
    const setting = fp.fromPairs(
        fp.map(setting => [setting.id, setting])(settingRecords));
    return generate(setting, endTime)(projects);
},
);

exports.Run = () => {
    const rule = new schedule.RecurrenceRule();
    rule.hour = 1;
    rule.minute = 0;
    // rule.second = 5;
    schedule.scheduleJob(rule, async () => {
        console.log(
            `Daily backend process for device daily bills, start from ${moment().
                format('YYYY-MM-DD hh:mm:ss')}`);
        return exports.bill(moment().subtract(1, 'day').endOf('day'));
    });
};

exports.ModuleName = 'DeviceDailyBills';

const usageOf = cost => (cost.endScale - cost.startScale) * 10000;
const scaleOf = cost => cost.endScale * 10000;
const heartbeatInProject = MySQL => async (timeFrom, timeTo, projectId) => {
    const groupingData = await MySQL.DeviceHeartbeats.findAll(
        {
            attributes: [
                'deviceId',
                [
                    MySQL.Sequelize.fn('max',
                        MySQL.Sequelize.col('total')), 'endScale'],
                [
                    MySQL.Sequelize.fn('min',
                        MySQL.Sequelize.col('total')), 'startScale']],
            group: ['deviceId'],
            where: {
                createdAt: {
                    $gte: formatMysqlDateTime(timeFrom),
                    $lte: formatMysqlDateTime(timeTo),
                },
            },
            include: [
                {
                    model: MySQL.HouseDevices,
                    required: true,
                    where: {
                        projectId,
                        endDate: 0,
                    },
                    attributes: ['projectId'],
                }],
        },
    );
    return fp.groupBy('deviceId')(fp.map(
        data => ({...data.toJSON(), startDate: timeFrom, endDate: timeTo}))(
        groupingData));
};

const allContracts = MySQL => async (
    projectId, dailyFrom) => MySQL.Contracts.findAll({
    where: {
        projectId,
        status: 'ONGOING',
    },
    attributes: ['id', 'roomId', 'userId', 'expenses'],
    include: [
        {
            model: MySQL.Rooms,
            as: 'room',
            include: [
                {
                    model: MySQL.HouseDevices,
                    as: 'devices',
                    where: {
                        endDate: {
                            $or: [
                                {$eq: 0},
                                {$gte: dailyFrom},
                            ],
                        },
                    },
                    required: true,
                },
            ],
            required: true,
        },
    ],
});

const costOfRoom = (houses, cost) => {
    const price = priceOfHouse(houses, cost.deviceId);
    const amount = amountOf(cost.endScale - cost.startScale, price);
    return {
        amount,
        price,
    };
};

const amountOf = (base, price) => {
    const baseBd = new bigdecimal.BigDecimal(base.toString());
    const priceBd = new bigdecimal.BigDecimal(price.toString());
    return baseBd.multiply(priceBd);
};

const priceOfHouse = (houseModels, deviceId) => {
    const houses = fp.map(a => a.toJSON())(houseModels);
    const deviceId2ElectricityPrice = fp.mapValues(
        fp.pipe(fp.head, fp.get('prices'),
            fp.find(fp.pipe(fp.get('type'), fp.eq('ELECTRIC'))),
            fp.getOr(0)('price')))(
        fp.groupBy('id')(fp.map(fp.pick(['id', 'prices']))(
            houses)));
    const houseIdOfDevices = (houses, deviceId) => fp.find(house => {
        const devices = fp.flatten(
            [house.devices, fp.flatten(fp.map('devices')(house.rooms))]);
        return fp.any(fp.pipe(fp.get('deviceId'), fp.eq(deviceId)))(
            devices);
    })(houses);
    const house = houseIdOfDevices(houses, deviceId);
    return fp.getOr(0)(house.id)(deviceId2ElectricityPrice);
};