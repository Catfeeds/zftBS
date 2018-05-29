'use strict';
require('include-node');
const moment = require('moment');
const {fn: momentProto} = require('moment');
const {deduct} = require('../../module/DailyPrepaid/DailyPrepaid');
const sinon = require('sinon');
const {spy, stub} = sinon;

const sandbox = sinon.sandbox.create();

const fixedMock = {
    Projects: {
        findAll: async () => [{id: 1}],
    },

    Sequelize: {
        transaction: async func => func({}),
        fn: () => {
        },
        col: () => {
        },
    },
    Literal: () => 1,
};
describe('DailyPrepaid', function() {
    before(() => {
        global.log = console;
        global.Util = Include('/libs/util');
        global.ErrorCode = Include('/libs/errorCode');
        global.SnowFlake = {
            next: () => 444222,
        };
        global.Message = {
            BalanceChange: () => ({}),
        };
        sandbox.stub(momentProto, 'unix');
        momentProto.unix.returns(2018);
    });
    after(() => {
        sandbox.restore();
    });
    it('should send out query as expected', async () => {
        const dailyPrepaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            Contracts: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 443,
                            roomId: 3322,
                            expenses: [
                                {
                                    configId: 123,
                                    pattern: 'prepaid',
                                    rent: 99,
                                }],
                            userId: 33221,
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100, locker: 1}),
                update: cashAccountUpdateSpy,
            },
            DailyPrepaid: {
                create: dailyPrepaidCreateSpy,
            },
            PrePaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
            ...fixedMock,
        };

        await deduct(moment()).then(() => {
            dailyPrepaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            cashAccountUpdateSpy.should.have.been.called;
            dailyPrepaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -99,
                    contractId: 443,
                    createdAt: 2018,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    projectId: 1,
                    configId: 123,
                });
            prePaidFlowsCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    category: 'daily',
                    contractId: 443,
                    id: 444222,
                    paymentDay: 2018,
                    projectId: 1,
                });
            cashAccountUpdateSpy.getCall(0).args.should.be.eql([
                {
                    balance: 1,
                    locker: 1,
                }, {
                    where: {
                        locker: 1,
                        userId: 33221,
                    },
                }]);
        });
    });
});