const fp = require('lodash/fp');
const bigdecimal = require('bigdecimal');
const moment = require('moment');
const schedule = require('node-schedule');
const {formatMysqlDateTime} = Include('/libs/util');
const innerValue = fp.map(j => j.toJSON());
const generateProject = dailyTo => async projectId => {
    const dailyFrom = moment(dailyTo).startOf('days').unix();
    const paymentDay = moment(dailyTo).unix();

    return allContracts(MySQL)(projectId, dailyFrom).then(innerValue).then(
        contracts => {
            if (!contracts.length) {
                log.info(`no contracts in project ${projectId}`);
                return;
            }

            const houseIds = fp.uniq(fp.compact(
                fp.map(fp.get('room.houseId'))(contracts)));

            let houseId2Rooms = {};
            let deviceId2Room = {};
            fp.each(contract => {
                if (!contract.room) {
                    return;
                }
                //todo: 是否合同生效当天就进行计费
                const roomExtension = fp.assign({
                    projectId,
                    contractId: contract.id,
                    userId: contract.userId,
                });
                const houseId = contract.room.houseId;

                if (!houseId2Rooms[houseId]) {
                    houseId2Rooms[houseId] = [];
                }
                houseId2Rooms[houseId].push(roomExtension(contract.room));

                fp.each(device => {
                    deviceId2Room[device.deviceId] = roomExtension(
                        contract.room);
                })(contract.room.devices);

            })(contracts);

            return Promise.all([
                Util.getHouses(projectId, dailyTo, 'CLIENT', houseIds).
                    then(fp.map(a => a.toJSON())),
                MySQL.HouseApportionment.findAll({
                    attributes: ['houseId', 'roomId', 'value'],
                    where: {
                        projectId,
                        houseId: {$in: houseIds},
                    },
                }),
            ]).then(
                ([houses, apportionments]) => {
                    const houseApportionment = houseIdRoomId2Share(
                        apportionments);

                    const deviceId2ElectricityPrice = devicesWithItsPrice(
                        houses);
                    const deviceIdDic = houseIdOfDevices(houses);
                    const deviceIds = allDeviceIds(houses);
                    const roomId2Contract = fp.groupBy('roomId')(contracts);
                    const contractedRooms = fp.flatten(
                        fp.map(fp.pipe(fp.get('rooms'),
                            fp.filter(fp.pipe(fp.get('id'),
                                fp.includes(fp, fp.keys(roomId2Contract))))))(
                            houses));
                    const house2ContractedRoom = fp.groupBy('houseId')(
                        contractedRooms);

                    const house2Contract = fp.mapValues(
                        fp.pipe(fp.map(contract => {
                            const roomId = fp.get('id')(contract);
                            return fp.get(roomId)(roomId2Contract);
                        }), fp.flatten))(house2ContractedRoom);

                    return heartbeatInProject(MySQL)(dailyFrom,
                        dailyTo.unix(),
                        projectId).
                        then(billOnHeartbeats(MySQL)({
                            deviceIds,
                            deviceId2Room,
                            houseApportionment,
                            deviceId2ElectricityPrice,
                            deviceIdDic,
                            houseId2Rooms,
                            projectId,
                            paymentDay,
                            house2Contract,
                        }));
                },
            );
        },
    );
    // .catch(err => {
    //     log.error(
    //         `error ${err} in calculating: project ${projectId} at time ${dailyTo}`);
    // });
};

const generate = endTime =>
    projects =>
        Promise.all(
            fp.map(fp.pipe(fp.get('id'), generateProject(endTime)))(
                projects)).
            then(() => log.warn('DeviceDailyBills Done...'));

exports.bill = endTime => MySQL.Projects.findAll({attributes: ['id']}).
    then(generate(endTime));

const devicesWithHeartbeats = (devicesWithPrice, heartbeats) => {
    const uniqueDeviceIdsFromHeartbeats = fp.flatten(
        fp.map(v => ({deviceId: v}))(
            fp.keys(heartbeats)));
    const deviceInDifference = fp.differenceBy(
        fp.pipe(fp.get('deviceId'), dId => dId.toString()))(devicesWithPrice)(
        uniqueDeviceIdsFromHeartbeats);
    const defaultTemplates = fp.groupBy('deviceId')(
        fp.map(fp.defaults({startScale: 0, endScale: 0}))(
            deviceInDifference));
    return fp.defaults(defaultTemplates)(heartbeats);
};

const payDevice = MySQL => async (devicePrePaid, room) => {
    const {userId, id: roomId, projectId} = room;
    const flowId = Util.newId();
    const prePaidObj = fp.assign(devicePrePaid,
        {id: Util.newId(), flowId: flowId});

    log.info('devicePrePaid: ', userId, prePaidObj);

    return Util.PayWithOwed(userId, prePaidObj.amount).then(
        ret => {
            if (ret.code !== ErrorCode.OK) {
                log.error('PayWithOwed in device daily failed', userId,
                    prePaidObj, roomId, ret);
                return;
            }

            const prePaidFlow = {
                id: flowId,
                projectId,
                contractId: devicePrePaid.contractId,
                paymentDay: devicePrePaid.paymentDay,
                amount: fp.getOr(0)('result.amount')(ret),
                balance: fp.getOr(0)('result.balance')(ret),
                category: 'device',
            };

            return Promise.all([
                MySQL.DevicePrepaid.create(prePaidObj),
                MySQL.PrepaidFlows.create(prePaidFlow)]).
                then(() => Message.BalanceChange(projectId, userId,
                    ret.amount,
                    ret.balance));
        },
    );
};

const searchRoomInHouse = rooms => roomId =>
    fp.find(
        fp.pipe(fp.get('roomId'), a => a.toString(), fp.eq(roomId.toString())))(
        rooms);
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
            required: true,
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
                    required: false,
                },
            ],

        },
    ],
});

const calcShare = (amountAndPrice, percent) => (
    new bigdecimal.BigDecimal(amountAndPrice.amount.toString())
).multiply(new bigdecimal.BigDecimal(percent.toString()),
).
    divide(new bigdecimal.BigDecimal('100'), 0,
        bigdecimal.RoundingMode.HALF_UP()).
    intValue();

const costOfRoom = (price, cost) => {
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

const priceOfHouse = (houseDictionary, deviceId2ElectricityPrice) =>
    deviceId => {
        const house = houseDictionary(deviceId);
        console.log('house price of house', house);
        return fp.getOr(0)(fp.get('id')(house))(deviceId2ElectricityPrice);
    };

const houseIdRoomId2Share = apportionments =>
    fp.mapValues(
        fp.pipe(fp.groupBy('roomId'),
            fp.mapValues(fp.pipe(fp.head, fp.get('value')))))(
        fp.groupBy('houseId')(
            fp.map(a => a.toJSON())(apportionments)));

const houseIdOfDevices = houses => deviceId => fp.find(house => {
    const devices = fp.flatten(
        [house.devices, fp.flatten(fp.map('devices')(house.rooms))]);
    return fp.any(fp.pipe(fp.get('deviceId'), fp.eq(deviceId)))(
        devices);
})(houses);

const allDeviceIds = houses => fp.flatten(fp.map(house => {
    const publicDevices = fp.map(
        fp.defaults({public: true, houseId: house.id}))(
        house.devices);
    const devicesInRooms = fp.map(
        room => fp.map(fp.defaults({public: false, houseId: room.houseId}))(
            fp.get('devices')(room)))(house.rooms);
    return fp.flatten([publicDevices, fp.flatten(devicesInRooms)]);
})(houses));

const devicesWithItsPrice = houses => {
    return fp.mapValues(
        fp.pipe(fp.head, fp.get('prices'),
            fp.find(fp.pipe(fp.get('type'), fp.eq('ELECTRIC'))),
            fp.getOr(0)('price')))(
        fp.groupBy('id')(fp.map(fp.pick(['id', 'prices']))(
            houses)));
};

const getAmountAndPrice = (deviceId2ElectricityPrice, deviceIdDic) => cost => {
    const price = priceOfHouse(
        deviceIdDic, deviceId2ElectricityPrice)(
        cost.deviceId);
    console.log('price', price);
    return costOfRoom(price, cost);
};
const getApportionment = (houseApportionment, houseId2Rooms) => houseId => {
    const apportionment = houseApportionment[houseId];
    return apportionment ?
        apportionment :
        Util.autoApportionment(
            fp.map('id')(houseId2Rooms[houseId]));
};

const billOnHeartbeats = MySQL => dataMap => heartbeats => {
    fp.each(fp.each(singleDeviceProcess(MySQL)(dataMap)))(
        devicesWithHeartbeats(dataMap.deviceIds, heartbeats));
};

const singleDeviceProcess =
    MySQL => ({
                  deviceIds, deviceId2Room,
                  houseApportionment,
                  deviceId2ElectricityPrice,
                  deviceIdDic, houseId2Rooms,
                  projectId, paymentDay, house2Contract,
              }) => reading => {

        const device = fp.find(
            fp.pipe(fp.get('deviceId'), fp.eq(reading.deviceId)))(
            deviceIds);
        const amountAndPrice = getAmountAndPrice(
            deviceId2ElectricityPrice, deviceIdDic)(
            reading);

        if (device.public) {
            const houseId = deviceIdDic(reading.deviceId).id;
            //公区表
            const apportionments = fp.toPairs(
                getApportionment(houseApportionment, houseId2Rooms)(
                    device.houseId));

            const contractOfRoom = searchRoomInHouse(house2Contract[houseId]);
            // console.log('device in public',
            //     apportionments, device);
            fp.each(([roomId, percent]) => {
                const {id: contractId, userId} = contractOfRoom(roomId);
                payDevice(MySQL)({
                    type: 'ELECTRICITY',
                    contractId,
                    projectId,
                    deviceId: reading.deviceId,
                    amount: -calcShare(amountAndPrice, percent),
                    scale: scaleOf(reading),
                    usage: usageOf(reading),
                    price: amountAndPrice.price,
                    share: percent,
                    paymentDay,
                    createdAt: moment().unix(),
                }, fp.defaults({userId, projectId})(device));
            })(apportionments);
        }

        //私有表
        const room = deviceId2Room[reading.deviceId];
        return room && payDevice(MySQL)({
            type: 'ELECTRICITY',
            contractId: room.contractId,
            projectId,
            deviceId: reading.deviceId,
            amount: -amountAndPrice.amount,
            scale: scaleOf(reading),
            usage: usageOf(reading),
            price: amountAndPrice.price,
            paymentDay,
            createdAt: moment().unix(),
        }, room);

    };

exports.Run = () => {
    const rule = new schedule.RecurrenceRule();
    rule.hour = 4;
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
