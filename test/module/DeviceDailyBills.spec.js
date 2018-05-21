'use strict';
require('include-node');
const moment = require('moment');
const {fn: momentProto} = require('moment');
const {bill} = require('../../module/DeviceDailyBills/DeviceDailyBills');
const sinon = require('sinon');
const spy = sinon.spy;

const sandbox = sinon.sandbox.create();

describe('DeviceDailyBills', function() {
    before(() => {
        global.log = console;
        global.Util = Include('/libs/util');
        global.ErrorCode = Include('/libs/errorCode');
        global.SnowFlake = {
            next: () => 444222,
        };
        sandbox.stub(momentProto, 'unix');
        momentProto.unix.returns(2018);
    });
    after(() => {
        sandbox.restore();
    });
    it('should send out query as expected', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        global.Message = {
            BalanceChange: () => ({}),
        };
        global.MySQL = {
            Projects: {
                findAll: async () => [{id: 1}],
            },
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [{deviceId: 199, endDate: 0}],
                            prices: [
                                {
                                    type: 'ELECTRIC',
                                    price: 10000,
                                }],
                            rooms: [
                                {
                                    id: 3322,
                                    devices: [
                                        {
                                            deviceId: 4444,
                                        },
                                    ],
                                    contractId: 443,
                                    userId: 33221,
                                }],
                        }),
                    }],
            },
            DeviceHeartbeats: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            deviceId: 4444,
                            startScale: 123,
                            endScale: 456,
                        }),
                    }],
            },
            Contracts: {
                findAll: async () => [
                    {
                        id: 443,
                        roomId: 3322,
                        room: {
                            id: 3322,
                            houseId: 1,
                            devices: [
                                {
                                    deviceId: 4444,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33221,
                    }],
            },
            HouseApportionment: {
                findAll: async () => [],
            },
            Settings: {
                findAll: async () => [],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: async () => [{id: 123}],
            },
            DevicePrePaid: {
                create: devicePrePaidCreateSpy,
            },
            PrePaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
            Sequelize: {
                transaction: async func => func({}),
                fn: () => {
                },
                col: () => {
                },
            },
            Literal: () => '1',
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -3330000,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 10000,
                    projectId: 1,
                    scale: 4560000,
                    type: 'ELECTRICITY',
                    usage: 3330000,
                });
            prePaidFlowsCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    category: 'device',
                    contractId: 443,
                    id: 444222,
                    paymentDay: 2018,
                    projectId: 1,
                });
        });
    });
    //TODO:
    it('should generate dailyPrepaid', async () => {});
    it('should share public meter', async () => {});
    it('should deal customised shared public meter', async () => {});
    it('should always share with 100%', async () => {});
    it('should handle pay exception', async () => {});
});