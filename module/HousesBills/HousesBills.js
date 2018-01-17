const fp = require('lodash/fp');
const _ = require('lodash');
const bigdecimal = require('bigdecimal');
const moment = require('moment');

const USAGE_EXT = 10000;

function generateProject(projectId, time) {
    //
    const makeHousesBills = (housesBills)=>{
        return new Promise((resolve, reject)=>{
            // log.info(housesBills);
            let bulkHousesBills = [];
            let bulkHousesBillFlows = [];
            const now = time.format('YYYYMMDD');
            _.forEach(housesBills, (billFlows, houseId)=>{
                const billId = SnowFlake.next();
                const amount = _.sum(fp.map(flow=>{
                    return flow.amount;
                })(billFlows));
                const flows = fp.map(flow=>{
                    return {
                        billId: billId,
                        deviceId: flow.deviceId,
                        amount: flow.amount,
                        scale: flow.scale,
                        usage: flow.usage,
                        price: flow.price,
                        createdAt: now
                    };
                })(billFlows);
                bulkHousesBillFlows = _.union(bulkHousesBillFlows, flows);
                log.info(flows);

                const housesBill = {
                    billId: billId,
                    projectId: projectId,
                    houseId: houseId,
                    createdAt: now,
                    amount: amount
                };
                bulkHousesBills.push(housesBill);
            });
            log.info(bulkHousesBills);

            MySQL.Sequelize.transaction(t=>{
                return Promise.all([
                    MySQL.HousesBills.bulkCreate(bulkHousesBills, {transaction: t}),
                    MySQL.HousesBillsFlows.bulkCreate(bulkHousesBillFlows, {transaction: t})
                ]).then(
                    ()=>{
                        resolve();
                    },
                    err=>{
                        reject(err);
                    }
                );
            });
        });
    };

    const timeStamp = time.unix();
    return new Promise((resolve, reject)=>{
        MySQL.Houses.findAll({
            where:{
                projectId: projectId,
                status:{$ne: 'DELETED'}
            },
            include:[
                {
                    model: MySQL.HouseDevicePrice,
                    as: 'prices',
                    attributes: ['sourceId', 'type', 'price']
                },
                {
                    model: MySQL.HouseDevices,
                    as: 'devices',
                    attributes:['deviceId', 'startDate', 'endDate'],
                    where:{
                        endDate: {$or:[
                            {$eq: 0},
                            {$lte: timeStamp}
                        ]}
                    }
                }
            ]
        }).then(
            houses=>{
                const deviceIds = _.flattenDeep(fp.map(house=>{
                    return fp.map(dev=>{
                        return dev.deviceId;
                    })(house.devices);
                })(houses));

                const housePriceMapping = _.fromPairs(fp.map(house=>{
                    return [
                        house.id, _.fromPairs(fp.map(price=>{
                                return [price.type, price.price]
                            })(house.prices))
                    ];
                })(houses));

                const deviceId2HouseId = _.fromPairs(_.flatten(fp.map(house=>{
                    return fp.map(dev=>{ return [dev.deviceId, house.id]; })(house.devices);
                })(houses)));


                const from = moment(time).subtract(1, 'days').endOf('days').unix();
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

                        houses;
                        //calculate device usage
                        let houseCostMapping = {};
                        _.each(houses, house=>{
                            _.each(house.devices, device=>{
                                const deviceId = device.deviceId;
                                if( !dataMapping[deviceId] ){
                                    return;
                                }

                                if( !dataMapping[deviceId]['11'] ){
                                    return;
                                }

                                const dataFilter = (data, endDate)=>{
                                    return _.compact(fp.map(d=>{
                                        const isValid = endDate === 0 || d.time<endDate;
                                        return isValid ? d : null;
                                    })(data));
                                };
                                const calc = (ary)=>{
                                    let usage = 0;
                                    for(let i=1; i<ary.length; i++){
                                        usage += ary[i].rateReading - ary[i-1].rateReading;
                                    }
                                    return usage;
                                };
                                const getScale = ()=>{
                                    return _.last(data).reading;
                                };

                                const data = dataFilter(dataMapping[deviceId]['11'], device.endDate);
                                if(_.isEmpty(data)){
                                    return;
                                }
                                const usage = calc(data);
                                const houseId = deviceId2HouseId[deviceId];
                                const priceObj = housePriceMapping[houseId];
                                if(_.isEmpty(priceObj)){
                                    return;
                                }

                                //only electric now
                                const base = new bigdecimal.BigDecimal(usage.toString());
                                const price = new bigdecimal.BigDecimal(priceObj.ELECTRIC.toString());
                                const cost = base.multiply(price);
                                if(!houseCostMapping[houseId]){
                                    houseCostMapping[houseId] = [];
                                }
                                const houseCost = {
                                    amount: cost.intValue(),
                                    scale: getScale(),
                                    deviceId: deviceId,
                                    usage: usage,
                                    price: priceObj.ELECTRIC
                                };
                                // log.info(houseCost, houseCost.price*houseCost.usage === houseCost.amount);
                                houseCostMapping[houseId].push(houseCost);
                            });
                        });

                        // make housesBills
                        makeHousesBills(houseCostMapping).then(
                            ()=>{
                                resolve();
                            }
                        );
                    }
                );

                // MongoDB.Sensor
                //     .find({
                //         key:{$in: deviceIds}
                //     })
                //     .select('_id key')
                //     .then(
                //         sensors=>{
                //
                //             const CUID2DeviceIdMapping = _.fromPairs(fp.map(sensor=>{
                //                 const deviceId = GUID.DeviceID(sensor.key).SensorCPTID();
                //                 return [sensor._id.toString(), deviceId];
                //             })(sensors));
                //
                //             const CUIDs = fp.map(sensor=>{return sensor._id.toString();})(sensors);
                //             const sql = `select sensor,value from ecdaily${time.format('YYYYMM')} where date='${time.format('YYYYMMDD')}' and sensor in(${EMMySQL.GenerateSQLInArray(CUIDs)})`;
                //             let houseCostMapping = {};
                //             EMMySQL.Exec(sql).then(
                //                 data=>{
                //                     _.each(data, d=>{
                //                         const deviceId = CUID2DeviceIdMapping[d.sensor];
                //                         const houseId = deviceId2HouseId[deviceId];
                //                         const priceObj = housePriceMapping[houseId];
                //
                //                         if(!houseCostMapping[houseId]){
                //                             houseCostMapping[houseId] = [];
                //                         }
                //
                //                         //only electric now
                //                         const base = new bigdecimal.BigDecimal(d.value);
                //                         const price = new bigdecimal.BigDecimal(priceObj.ELECTRIC.toString());
                //                         const cost = base.multiply(price);
                //                         houseCostMapping[houseId].push({
                //                             cost: cost.intValue(),
                //                             deviceId: deviceId,
                //                             usage: d.value,
                //                             price: priceObj.ELECTRIC
                //                         });
                //                     });
                //
                //                     //make housesBills
                //                     makeHousesBills(houseCostMapping).then(
                //                         ()=>{
                //                             resolve();
                //                         }
                //                     );
                //                 }
                //             );
                //         }
                //     );
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
        // setTimeout(function(){
        //     setTimeout(function(){
                let m = moment('2017 1228 0100', 'YYYY MMDD HHmm');
                // let m = moment();
                let timePoint = m.format('HHmm');
                // log.info('check payment time: ', m.format('YYYY-MM-DD HH:mm:ss'));
                if(timePoint === '0100'){
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
                // tryPayment();
            // }, 1000 * 60);
        // }, 0);
    };
    tryPayment();
};

exports.ModuleName = 'HousesBills';