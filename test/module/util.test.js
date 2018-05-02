'use strict';
require('include-node');
// const fp = require('lodash/fp');
const sinon = require('sinon');

describe('util.test.js', function() {
    before(() => {
        global.log = console;
        global.Util = Include('/libs/util');
    });
    after(() => {
    });

    it('filterValidDeviceData shoud return all data when endDate is 0', async()=>{
        const deviceData = [
            {
                rateReading: 100,
                reading: 100,
                time: 1523289600
            },
            {
                rateReading: 110,
                reading: 110,
                time: 1523376000
            },
            {
                rateReading: 120,
                reading: 120,
                time: 1523462400
            },
        ];

        const spy = sinon.spy( Util, 'filterValidDeviceData' );
        Util.filterValidDeviceData( deviceData, 0 );
        spy.getCall(0).returnValue[0].should.be.eql(deviceData[0]);
    });
});