'use strict';

describe('first test', () => {
    it('should allow promise testing', async () => {
        await Promise.resolve(1).should.eventually.equal(1);
    });
});