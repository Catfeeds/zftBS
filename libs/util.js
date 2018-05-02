const _ = require('lodash');
const moment = require('moment');
const fp = require('lodash/fp');
const bigdecimal = require('bigdecimal');

async function Pay(userId, amount, t, payAble) {

    const MAX_LOCK = 4294967000;

    const cashAccount = await MySQL.CashAccount.findOne({
        where:{
            userId: userId
        }
    });

    if(!cashAccount){
        return ErrorCode.ack(ErrorCode.USERNOTEXISTS);
    }

    if(payAble && cashAccount.balance+amount < 0){
        return ErrorCode.ack(ErrorCode.CASHNOTENOUGH);
    }

    try {
        const options = _.assign(
            {
                where: {
                    userId: userId,
                    locker: cashAccount.locker
                }
            },
            t ? {transaction: t} : {}
        );

        const result = await MySQL.CashAccount.update(
            {
                balance: MySQL.Literal(`balance+${amount}`),
                locker: cashAccount.locker > MAX_LOCK ? 1: MySQL.Literal('locker+1')
            },
            options
        );
        if(!result || !result[0]){
            //save failed
            throw new Error(ErrorCode.LOCKDUMPLICATE);
        }
    }
    catch(err){
        if(err.message === ErrorCode.LOCKDUMPLICATE.toString()){
            return ErrorCode.ack(ErrorCode.LOCKDUMPLICATE);
        }
        else {
            log.error('pay error', userId, amount, err);
            return ErrorCode.ack(ErrorCode.DATABASEEXEC);
        }
    }

    return ErrorCode.ack(ErrorCode.OK, {balance: cashAccount.balance + amount, amount: amount, userId: userId});
}


exports.PayWithOwed = async(userId, amount, t, payAble)=>{
    let count = 8;
    let ret;
    do {
        ret = await Pay(userId, amount, t, payAble);
        if(payAble && ret.code === ErrorCode.CASHNOTENOUGH){
            break;
        }
    }while( count && ret.code !== ErrorCode.OK );

    return ret;
};

exports.getHouses = async(projectId, time, category, houseIds)=>{
    const timeStamp = time.unix();
    const preDay = moment(time).subtract(1, 'days').startOf('days').unix();

    const where = _.assign(
        {
            projectId: projectId,
            status:{$ne: 'DELETED'}
        },
        houseIds ? { id:{$in: houseIds}} : {}
    );

    return MySQL.Houses.findAll({
        where: where,
        include:[
            {
                model: MySQL.HouseDevicePrice,
                as: 'prices',
                where:{
                    category: category
                },
                required: false,
                attributes: ['houseId', 'category', 'type', 'price']
            },
            {
                model: MySQL.HouseDevices,
                as: 'devices',
                required: false,
                attributes:['deviceId', 'startDate', 'endDate', 'public'],
                where:{
                    endDate: {
                        $or:[
                            {$eq: 0},
                            {$gte: preDay}
                        ]
                    },
                    startDate: {$lte: timeStamp}
                }
            },
            {
                model: MySQL.Rooms,
                as: 'rooms',
                requried: false,
                include:[
                    {
                        model: MySQL.HouseDevices,
                        as: 'devices',
                        required: true
                    }
                ]
            }
        ]
    });
};

exports.dailyDeviceData = (houses, time)=>{
    const deviceId2HouseId = fp.fromPairs(fp.flatten(fp.map(house => {
        const houseDev = fp.map(dev => {
            return [dev.deviceId, house.id];
        })(house.devices);
        const roomDev = fp.flatten(fp.map(room => {
            return fp.map(dev => {
                return [dev.deviceId, house.id];
            })(room.devices);
        })(house.rooms));
        return fp.flatten([houseDev, roomDev]);
    })(houses)));
    const housePriceMapping = fp.fromPairs(fp.map(house => {
        return [
            house.id, _.fromPairs(fp.map(price => {
                return [price.type, price.price];
            })(house.prices)),
        ];
    })(houses));
    const deviceIds = fp.flattenDeep(fp.map(house=>{
        return [
            fp.map(dev=>{
                return dev.deviceId;
            })(house.devices)
            ,fp.map(room=>{
                fp.map(dev=>{
                    return dev.deviceId;
                })(room.devices);
            })(house.rooms)
        ];
    })(houses)); 

    const from = moment(time).subtract(2, 'days').endOf('days').unix();
    const timeStamp = moment(time).subtract(1, 'days').endOf('days').unix();

    return new Promise((resolve, reject)=>{
        MySQL.DevicesData.findAll({
            where:{
                deviceId:{$in: deviceIds},
                time:{$between:[from, timeStamp]}
            },
            attributes:['deviceId', 'channelId', 'reading', 'rateReading', 'time'],
            order:[['time', 'asc']]
        }).then(
            devicesData=>{
                let dataMapping = {};
                _.each(devicesData, data=>{
                    const deviceId = data.deviceId;
                    const channelId = data.channelId;

                    if(!dataMapping[deviceId]){
                        dataMapping[deviceId] = {};
                    }

                    if(!dataMapping[deviceId][channelId]){
                        dataMapping[deviceId][channelId] = [];
                    }

                    dataMapping[deviceId][channelId].push({
                        rateReading: data.rateReading,
                        reading: data.reading,
                        time: data.time
                    });
                });

                //calculate device usage
                let houseCostMapping = {};
                _.each(houses, house=> {
                    _.each(house.devices, device => {
                        const deviceId = device.deviceId;
                        if (!dataMapping[deviceId]) {
                            return;
                        }

                        if (!dataMapping[deviceId]['11']) {
                            return;
                        }

                        const dataFilter = (data, endDate) => {
                            return _.compact(fp.map(d => {
                                const isValid = endDate === 0 || d.time < endDate;
                                return isValid ? d : null;
                            })(data));
                        };
                        const calc = (ary) => {
                            let usage = 0;
                            for (let i = 1; i < ary.length; i++) {
                                usage += ary[i].rateReading - ary[i - 1].rateReading;
                            }
                            return usage;
                        };
                        const getScale = () => {
                            return _.last(data).reading;
                        };

                        const data = dataFilter(dataMapping[deviceId]['11'], device.endDate);
                        if (_.isEmpty(data) || data.length === 1) {
                            log.error(deviceId, ' data is empty or less then 2', data);
                            return;
                        }
                        const usage = calc(data);
                        const houseId = deviceId2HouseId[deviceId];
                        const priceObj = housePriceMapping[houseId];

                        //only electric now
                        const base = new bigdecimal.BigDecimal(usage.toString());
                        const price = new bigdecimal.BigDecimal(_.get(priceObj, 'ELECTRIC', 0).toString());
                        const cost = base.multiply(price).divide(new bigdecimal.BigDecimal('10000'), 0, bigdecimal.RoundingMode.DOWN());

                        if (!houseCostMapping[houseId]) {
                            houseCostMapping[houseId] = [];
                        }
                        const houseCost = {
                            houseId: house.id,
                            amount: cost.intValue(),
                            scale: getScale(),
                            public: device.public,
                            deviceId: deviceId,
                            usage: usage,
                            price: _.get(priceObj, 'ELECTRIC', 0)
                        };
                        // log.info(houseCost, houseCost.price*houseCost.usage === houseCost.amount);
                        houseCostMapping[houseId].push(houseCost);
                    });
                });

                // make housesBills
                resolve(houseCostMapping);
            }
        );
    });
};

exports.autoApportionment = (roomIds)=>{
    const auto = (roomIds)=>{
        const count = roomIds.length;
        if(!count){
            return [];
        }
        let base = Math.floor(100/count);
        let suffix = 0;
        if(base*count !==  100){
            suffix = 100 - base * count;
        }

        const minRoomId = _.min(roomIds);
        const share = _.fromPairs(fp.map(roomId=>{
            if(roomId === minRoomId){
                return [roomId, base + suffix];
            }
            return [roomId, base];
        })(roomIds));
        return share;
    };

    return auto(roomIds);
};

exports.newId = ()=>{
    return SnowFlake.next();
};