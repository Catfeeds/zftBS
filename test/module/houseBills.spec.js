'use strict';
require('include-node');
const moment = require('moment');
const {fn: momentProto} = require('moment');
const fp = require('lodash/fp');
const {bill} = require('../../module/HousesBills/HousesBills');
const sinon = require('sinon');
const spy = sinon.spy;

const sandbox = sinon.sandbox.create();

describe('HouseBills', function() {
    before(() => {
        global.log = console;
        global.Util = Include('/libs/util');
        global.SnowFlake = {
            next: fp.uniqueId,
        };
        sandbox.stub(momentProto, 'unix');
        momentProto.unix.returns(2018);
    });
    after(() => {
        sandbox.restore();
    });
    it('should send out query as expected', async () => {
        const bulkBillCreateSpy = spy();
        const bulkBillFlowsCreateSpy = spy();
        global.MySQL = {
            Projects: {
                findAll: async () => [{id: 1}],
            },
            Houses: {
                findAll: async () => [
                    {
                        id: 1,
                        devices: [{deviceId: 199, endDate: 0}],
                        prices: [
                            {
                                type: 'ELECTRIC',
                                price: 10000,
                            }],
                        rooms: [],
                    }],
            },
            DevicesData: {
                findAll: async () => [
                    {
                        deviceId: 199,
                        channelId: '11',
                        reading: 3,
                        rateReading: 100,
                        time: 5,
                    },
                    {
                        deviceId: 199,
                        channelId: '11',
                        reading: 100,
                        rateReading: 900,
                        time: 500,
                    }],
            },
            HousesBills: {
                bulkCreate: bulkBillCreateSpy,
            },
            HousesBillsFlows: {
                bulkCreate: bulkBillFlowsCreateSpy,
            },
            Sequelize: {
                transaction: async func => func({}),
            },
        };

        await bill(moment()).then(() => {
            bulkBillCreateSpy.should.have.been.called;
            bulkBillFlowsCreateSpy.should.have.been.called;
            bulkBillCreateSpy.getCall(0).args[0].should.be.eql([
                {
                    amount: 800,
                    billId: '1',
                    createdAt: 2018,
                    houseId: '1',
                    paymentDay: 2018,
                    projectId: 1,
                }]);
            bulkBillFlowsCreateSpy.getCall(0).args[0].should.be.eql([
                {
                    amount: 800,
                    billId: '1',
                    createdAt: 2018,
                    deviceId: 199,
                    paymentDay: 2018,
                    price: 10000,
                    scale: 100,
                    usage: 800,
                }]);
        });
    });
});