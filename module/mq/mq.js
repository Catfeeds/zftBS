const _ = require('lodash');
const config = require('config');
const messageQueue = Include('/libs/messageQueue');

exports = module.exports = function(){};

const BROADCAST_TOPIC = 'BROADCAST';

let productorBroadcast;

exports.Run = function()
{
    const productorBroadCastName = `${BROADCAST_TOPIC}_${config.env}`;
    productorBroadcast = messageQueue.alloc(
        productorBroadCastName
        , config.redis_host
        , config.redis_port
        , config.redis_passwd
    );
    productorBroadcast.bind(productorBroadCastName);
};

exports.BroadCast = (message)=>{
    productorBroadcast.publish(message);
};

exports.ModuleName = 'MQ';