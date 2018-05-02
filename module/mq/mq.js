const config = require('config');
const messageQueue = Include('/libs/messageQueue');

exports = module.exports = function(){};

const BROADCAST_TOPIC = 'BROADCAST';

let producerBroadcast;

exports.Run = function()
{
    const producerBroadCastName = `${BROADCAST_TOPIC}_${config.env}`;
    producerBroadcast = messageQueue.alloc(
        producerBroadCastName
        , config.redis_host
        , config.redis_port
        , config.redis_passwd
    );
    producerBroadcast.bind(producerBroadCastName);
};

exports.BroadCast = (message)=>{
    producerBroadcast.publish(message);
};

exports.ModuleName = 'MQ';