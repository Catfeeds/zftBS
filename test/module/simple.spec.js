'use strict';

describe('first test', function () {
  it('should allow promise testing', function () {
    return Promise.resolve(1).should.eventually.equal(1);
  });
});