const moment = require('moment');
const fp = require('lodash/fp');
const _ = require('lodash');

const MessageType = {
    NTF_BALANCEINSUFFICIENT: 5300,  //余额不足
    NTF_ACCOUNTARREARS: 5301,       //账户欠费
    NTF_ARREARSSTOPSERVICES: 5303,  //停服断电
    NTF_ACCOUNTNEW: 5305,           //创建账户
    NTF_RENTBILL: 5400,             //房租账单
    NTF_BILLEXPIRED: 5401,          //账单过期
};

function send(messageTypeId, body){
    const obj = {
        id: SnowFlake.next(),
        timestamp: moment().unix(),
        messageTypeId: messageTypeId,
        param: body
    };
    MySQL.EventQueue.create(obj).then(
        ()=>{},
        err=>{
            log.error(err, messageTypeId, body, obj);
        }
    );
}

function bulkSend(messageTypeId, messages) {
    const now = moment().unix();
    const bulkMessages = fp.map(message=>{
        return {
            id: SnowFlake.next(),
            timestamp: now,
            messageTypeId: messageTypeId,
            param: message
        }
    })(messages);
    MySQL.EventQueue.bulkCreate(bulkMessages).then(
        ()=>{},
        err=>{
            log.error(err, messageTypeId, body, obj);
        }
    );
}

exports.createNewAccount = (projectId, userId, account, passwd)=>{
    send(MessageType.NTF_ACCOUNTNEW, {
        projectId: projectId,
        userId: userId,
        account: account,
        passwd: passwd
    });
};

exports.bulkRentBill = (bills)=>{
    bulkSend(MessageType.NTF_RENTBILL, bills);
};
exports.bulkBillExpired = (bills)=>{
    bulkSend(MessageType.NTF_BILLEXPIRED, bills);
};
