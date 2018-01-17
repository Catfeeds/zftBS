const fp = require('lodash/fp');
const _ = require('lodash');
const moment = require('moment');

function generateProject(projectId, time) {
    //
    return new Promise((resolve, reject)=>{

        const endIn2DaysFrom = moment(time).startOf('days').unix();
        const endIn2DaysTo = moment(time).add(2,'days').startOf('days').unix();

        const over1DayFrom = moment(time).subtract(1, 'days').startOf('days').unix();
        const over1DayTo = moment(time).subtract(1, 'days').endOf('days').unix();

        const getBills = (from, to)=>{
            return MySQL.Contracts.findAll({
                where:{
                    projectId: projectId,
                },
                include:[
                    {
                        model: MySQL.Bills,
                        as: 'bills',
                        where:{
                            flow: 'receive',
                            endDate: {$between: [from, to]},
                        },
                        include:[
                            {
                                model: MySQL.BillPayment,
                                as: 'payments'
                            }
                        ]
                    }
                ]
            })
        };

        Promise.all([
            getBills(endIn2DaysFrom, endIn2DaysTo),
            getBills(over1DayFrom, over1DayTo)
        ]).then(
            result=>{
                const endIn2Days = result[0];
                const over1Day = result[1];

                const getUnPayed = (bills)=>{
                    return fp.map(item=>{
                        const amount = _.sum(
                            _.compact(fp.map(bill=>{
                                if(!bill.payments.length){
                                    return bill.dueAmount;
                                }
                                else{
                                    return null;
                                }
                            })(item.bills)));
                        return {
                            projectId: projectId,
                            userId: item.userId,
                            amount: amount/100
                        };
                    })(bills);
                };

                {

                    const billsWillEnding = getUnPayed(endIn2Days);
                    Message.bulkRentBill(billsWillEnding);
                }

                {
                    //over1Day
                    const billsOverd = getUnPayed(over1Day);
                    Message.bulkBillExpired(billsOverd);
                }
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
    let tryHints = function ()
    {
        setTimeout(function(){
            setTimeout(function(){
                // let m = moment('2018 0714 0100', 'YYYY MMDD HHmm');
                let m = moment();
                let timePoint = m.format('HHmm');
                // log.info('check payment time: ', m.format('YYYY-MM-DD HH:mm:ss'));
                if(timePoint === '0100'){
                    //
                    if(!lastPaymentTime || lastPaymentTime.format('YYYYMMDD') !== m.format("YYYYMMDD")){
                        lastPaymentTime = moment(m);

                        MySQL.Projects.findAll({}).then(
                            projects=>{
                                generate( projects, m );
                            }
                        );
                    }
                }
                tryHints();
            }, 1000 * 60);
        }, 0);
    };
    tryHints();
};

exports.ModuleName = 'HousesBills';