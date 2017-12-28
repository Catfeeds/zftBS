const fp = require('lodash/fp');
const _ = require('lodash');
const bigdecimal = require('bigdecimal');
const moment = require('moment');

const USAGE_EXT = 10000;

function generateProject(projectId, externalId, time) {
    //
    return new Promise((resolve, reject)=>{
        const billTimestamp = time.unix();
        const now = moment().unix();
        const date = Number(time.format('YYYYMMDD'));
        MySQL.Houses.findAll({
            where:{
                status: 'OPEN',
                '$rooms.status$': 'INUSE'
            },
            include:[
                {
                    model: MySQL.Rooms,
                    as: 'rooms',
                    include:[
                        {
                            model: MySQL.HouseDevices,
                            as: 'devices',
                            required: true
                        },
                        {
                            model: MySQL.Contracts,
                            as: 'contracts',
                            where:{
                                to:{$gte: billTimestamp},
                                from:{$lte: billTimestamp}
                            }
                        }
                    ]
                },
                {
                    model: MySQL.HouseDevices,
                    as: 'devices',
                    where:{
                        public: true
                    }
                }
            ]
        }).then(
            houses=>{

                const monthStart = time.startOf('month');
                const monthEnd = time.endOf('month');

                const deviceIds = _.flattenDeep(fp.map(house=>{
                    return _.union(fp.map(dev=>{return dev.deviceId;})(house.devices),
                        _.flattenDeep(fp.map(room=>{
                            return fp.map(dev=>{return dev.deviceId;})(room.devices);
                        })(house.rooms))
                    );
                })(houses));

                MySQL.HousesBillsFlows.findAll({
                    where:{
                        deviceId:{$in: deviceIds},
                        createdAt: date
                    }
                }).then(
                    flows=>{
                        const deviceCostMapping = _.fromPairs(fp.map(flow=>{
                            return [flow.deviceId, flow.amount];
                        })(flows));

                        _.each(houses, house=>{
                            _.each(house.rooms, room=>{
                                //create bill
                                const bill = {
                                    flow: 'pay',
                                    entityType: 'property',
                                    contractId: room.contracts[0].id,
                                    userId: room.contracts[0].userId,
                                    projectId: projectId,
                                    source: 'device',
                                    type: 'extra',
                                    startDate: monthStart.unix(),
                                    endDate: monthEnd.unix(),
                                    dueDate: 0,
                                    createdAt: monthStart.unix()
                                };

                                MySQL.Bills.findOrCreate({
                                    where: bill,
                                    defaults: bill,
                                }).then(
                                    result=>{
                                        if(!result){
                                            return;
                                        }
                                        const billIns = result[0];

                                        const devicesBills = fp.map(dev=>{
                                            const cost = deviceCostMapping[dev.deviceId];
                                            if(cost === null || cost === undefined){
                                                return;
                                            }
                                            return {
                                                billId: billIns.id,
                                                projectId: projectId,
                                                relevantId: Number( dev.deviceId.substr(3) ),
                                                amount: cost,
                                                createdAt: now
                                            };
                                        })(room.devices);
                                        const amount = _.sum(fp.map(bill=>{return bill.amount;})(devicesBills));

                                        MySQL.Sequelize.transaction(t=>{
                                            return MySQL.Bills.increment(
                                                {
                                                    dueAmount: amount
                                                },
                                                {
                                                    where:{
                                                        id: bill.id
                                                    },
                                                    transaction: t
                                                }
                                            ).then(
                                                ()=>{
                                                    return MySQL.BillFlows.bulkCreate(devicesBills, {transaction: t});
                                                }
                                            );
                                        });
                                    }
                                );
                            });
                        });

                        resolve();
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
    generateProject(project.pid, project.externalId, time).then(
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
                // let m = moment('2017 1225 0800', 'YYYY MMDD HHmm');
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