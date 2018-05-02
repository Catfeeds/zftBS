'use strict';

const messageQueue = Include('/libs/messageQueue');

describe('Message Queue', () => {
    before(() => {
        global.log = {sys: console.log};
    });
    it('should walk through happy path', async () => {
        const productorBroadcast = messageQueue.alloc(
            'productorBroadCastName'
            , 'config.redis_host'
            , 'config.redis_port'
            , 'config.redis_passwd'
        );
        const index = productorBroadcast.register({});
        index.should.be.equal(0);
        productorBroadcast.listen('queueName');
        productorBroadcast.queue.should.be.eql('queueName');
        //TODO: try to come up something useful later
    });
});