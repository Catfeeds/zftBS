const fp = require('lodash/fp');
const _ = require('lodash');
const moment = require('moment');

function generateProject(projectId, time, agentFundChannel) {
    //
    return new Promise((resolve, reject)=>{

        const payTimeFrom = moment(time).startOf('days').unix();
        const payTimeTo = moment(time).endOf('days').unix();

        MySQL.Bills.findAll({
            where:{
                projectId: projectId,
                dueDate: {$between: [payTimeFrom, payTimeTo]}
            },
            include:[
                {
                    model: MySQL.Contracts,
                    as: 'contract'
                }
            ]
        }).then(
            bills=>{
                _.each(bills, bill=>{
                    if(!bill.contract){
                        return log.error('bill can not match contract', bill.toJSON());
                    }
                    const flowId = Util.newId();
                    const orderNo = Util.newId();
                    const payBill = {
                        id: Util.newId(),
                        projectId: projectId,
                        billId: bill.id,
                        orderNo: orderNo,
                        flowId: flowId,
                        fundChannelId: agentFundChannel.id,
                        amount: bill.dueAmount,
                        operator: 0,
                        paidAt: moment().unix(),
                    };
                    const flow = {
                        id: payBill.flowId,
                        projectId: projectId,
                        category: 'topup'
                    };
                    const agentChannelFlow = {
                        id: Util.newId(),
                        category: 'BILL',
                        orderNo: orderNo,
                        projectId: projectId,
                        fundChannelId: agentFundChannel.id,
                        billId: bill.id,
                        from: bill.contract.userId,
                        to: 0,
                        amount: bill.dueAmount
                    };

                    (async()=>{
                        try {
                            const t = await MySQL.Sequelize.transaction();
                            const result = await Util.PayWithOwed(bill.contract.userId, -bill.dueAmount, t, true);
                            if (result.code !== ErrorCode.OK) {
                                //pay failed
                                return log.warn('pay failed: ', bill.toJSON(), agentFundChannel.toJSON());
                            }

                            await MySQL.BillPayment.create(payBill, {transaction: t});
                            await MySQL.Flows.create(flow, {transaction: t});
                            await MySQL.FundChannelFlows.create(agentChannelFlow, {transaction: t});
                        }
                        catch(e){
                            log.error(e, bill);
                        }
                    })();

                });

                resolve();
            }
        );
    });
}

function generate(projects, time, agentFundChannel) {
    if(!projects.length){
        return log.warn('billPayment Done...')
    }

    const next = ()=>{
        return setImmediate(()=>{
            generate(_.tail(projects));
        })
    };

    const project = _.head(projects);

    MySQL.Settings.findOne({
        where:{
            projectId: project.id,
            key: 'billsPrePaid'
        }
    }).then(
        setting=>{
            if(!setting || setting.value === 'OFF' ){
                log.warn(' project billsPrePaid is OFF', project);
                return next();
            }

            generateProject(project.id, time, agentFundChannel).then(
                ()=>{
                    next();
                }
            );
        }
    );
}

exports.Run = ()=>{
    let lastPaymentTime;
    let tryHints = function ()
    {
        setTimeout(function(){
            setTimeout(function(){
                // let m = moment('2017 1218 1700', 'YYYY MMDD HHmm');
                let m = moment();
                let timePoint = m.format('HHmm');
                // log.info('check payment time: ', m.format('YYYY-MM-DD HH:mm:ss'));
                if(timePoint === '1700'){
                    //
                    if(!lastPaymentTime || lastPaymentTime.format('YYYYMMDD') !== m.format("YYYYMMDD")){
                        lastPaymentTime = moment(m);

                        Promise.all([
                            MySQL.Projects.findAll({}),
                            MySQL.FundChannels.findOne({
                                where:{
                                    flow: 'receive',
                                    projectId: 0,
                                    category: 'sys',
                                    tag: 'balance'
                                }
                            })
                        ]).then(
                            result=>{
                                if(!result[1]){
                                    return log.error('agent FundChannel empty');
                                }

                                generate( result[0], m, result[1] );
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

exports.ModuleName = 'BillPayment';