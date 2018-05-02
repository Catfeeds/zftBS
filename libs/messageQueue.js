const redis = require('redis');
const fp = require('lodash/fp');

class MessageQueue {

    constructor(name, host, port, passwd, retryTime){
        this.name = name;
        log.sys('redis create ', name, host, port, passwd);
        this.client = redis.createClient({
            password: passwd,
            host: host,
            port: port,
            retry_strategy: (options)=>{
                //
                log.error(options.error, options.total_retry_time, options.attempt);
                return retryTime || 5;
            }
        });
        this.client.auth(passwd);
        this.callback = [];
        this.queue = '';
    }

    listen(queueName){
        let _this = this;
        _this.client.subscribe(queueName);
        _this.client.on('subscribe', function (channel, count) {
            log.sys('MessageQueue: ', _this.name, 'Subscribe: ', channel, count);
        });
        _this.client.on('message', function (channel, message) {
            try{
                message = JSON.parse(message);
            }
            catch(e){
                message = {};
            }
            log.sys('MessageQueue: ', _this.name, 'Message: ', channel, message);
            if(fp.isEmpty(message)){
                return;
            }

            let validCallback = [];
            fp.each(function (callback) {
                if(callback){
                    validCallback.push(callback);
                    if(callback.Match(message)) {
                        callback.Do(message);
                    }
                }
            })(_this.callback);
            _this.callback = validCallback;
        });
        _this.queue = queueName;
    }

    bind(queueName){
        let _this = this;
        log.sys('MessageQueue: ', _this.name, ' Bind On: ', queueName);
        _this.queue = queueName;
    }

    register(func){
        let _this = this;
        let index = _this.callback.length;
        _this.callback.push(func);
        return index;
    }
    unRegister(index){
        let _this = this;
        if(index > _this.callback.length ){
            return;
        }
        _this.callback[index] = null;
    }

    publish(message){
        let _this = this;
        if(fp.isObject(message)){
            message = JSON.stringify(message);
        }
        log.sys(message);
        _this.client.publish(_this.queue, message);
    }
}

exports.alloc = (name, host, port, passwd, retryTime)=>{
    return new MessageQueue(name, host, port, passwd, retryTime);
};