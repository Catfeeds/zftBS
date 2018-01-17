const _ = require('lodash');

async function Pay(userId, amount) {

    const MAX_LOCK = 4294967000;

    const cashAccount = await MySQL.CashAccount.findOne({
        where:{
            userId: userId
        }
    });

    if(!cashAccount){
        return ErrorCode.ack(ErrorCode.USERNOTEXISTS);
    }

    try {
        const result = MySQL.CashAccount.update(
            {
                cash: MySQL.Literal(`cash+${amount}`),
                locker: cashAccount.locker > MAX_LOCK ? 1: MySQL.Literal(`locker+1`)
            },
            {
                where: {
                    locker: cashAccount.locker
                }
            }
        );
        if(!result || !result[0]){
            //save failed
            throw new Error(ErrorCode.LOCKDUMPLICATE);
        }
    }
    catch(err){
        log.error('pay error', userId, amount, err);

        if(err.message === ErrorCode.LOCKDUMPLICATE){
            return ErrorCode.ack(ErrorCode.LOCKDUMPLICATE);
        }
        else {
            return ErrorCode.ack(ErrorCode.DATABASEEXEC);
        }
    }

    return ErrorCode.ack(ErrorCode.OK, {balance: cashAccount.cash + amount, amount: amount, userId: userId});
}


exports.PayWithOwed = async(userId, amount)=>{

    let count = 4;
    let ret;
    do {
        ret = await Pay(userId, amount);
    }while(count && ret.code !== ErrorCode.OK);

    return ret;
};

