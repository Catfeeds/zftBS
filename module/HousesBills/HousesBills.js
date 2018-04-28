const fp = require('lodash/fp');
const _ = require('lodash');
const bigdecimal = require('bigdecimal');
const moment = require('moment');

function generateProject(projectId, time) {
    //
    const makeHousesBills = (housesBills)=>{
        return new Promise((resolve, reject)=>{
            // log.info(housesBills);
            let bulkHousesBills = [];
            let bulkHousesBillFlows = [];

            const paymentDay = time.unix();

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
                        paymentDay: paymentDay,
                        createdAt: moment().unix()
                    };
                })(billFlows);
                bulkHousesBillFlows = _.union(bulkHousesBillFlows, flows);
                log.info(flows);

                const housesBill = {
                    billId: billId,
                    projectId: projectId,
                    houseId: houseId,
                    paymentDay: paymentDay,
                    createdAt: moment().unix(),
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

    return new Promise((resolve, reject)=>{
        Util.getHouses(projectId, time, 'HOST').then(
            houses=>{
                Util.dailyDeviceData(houses, time).then(
                    houseCostMapping=>{
                        if(_.isEmpty(houseCostMapping)){
                            return resolve();
                        }
                        // make housesBills
                        makeHousesBills(houseCostMapping).then(
                            ()=>{
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
            generate(_.tail(projects), time);
        })
    };

    const project = _.head(projects);
    generateProject(project.id, time).then(
        ()=>{
            next();
        }
    );
}

function bill(time) {
    let timePoint = time.format('HHmm');
    // log.info('check payment time: ', m.format('YYYY-MM-DD HH:mm:ss'));
    if(timePoint === '0100'){
        //
        time.subtract(1, 'day').endOf('day');

        MySQL.Projects.findAll({}).then(
            projects=>{
                generate( projects, time );
            }
        );
    }
}

function batchBill() {
    const timeFrom = moment('2017 0701 0100', 'YYYY MMDD HHmm');
    const timeTo = moment('2018 0315 0100', 'YYYY MMDD HHmm');

    MySQL.Projects.findAll({}).then(
        projects=>{

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
                        })
                    };

                    const project = _.head(projects);
                    generateProject(project.id, timeIndex).then(
                        ()=>{
                            log.info(project.name, 'done');
                            next();
                        }
                    );
                };

                log.info('doing ', timeIndex.format('YYYYMMDD'));
                projectsBill(projects);
            };

            doBill(timeFrom);
        }
    );
}

exports.Run = ()=>{
    let tryPayment = function()
    {
        setTimeout(function(){
            setTimeout(function(){
                let m = moment();
                bill(m);
                tryPayment();
            }, 1000 * 60);
        }, 0);
    };
    tryPayment();

    // batchBill();
};

exports.ModuleName = 'HousesBills';