'use strict';
require('include-node');
const moment = require('moment');
const {fn: momentProto} = require('moment');
const {bill} = require('../../module/DeviceDailyBills/DeviceDailyBills');
const sinon = require('sinon');
const {spy, stub} = sinon;

const sandbox = sinon.sandbox.create();

const fixedMock = {
    Projects: {
        findAll: async () => [{id: 1}],
    },
    HouseApportionment: {
        findAll: async () => [],
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
describe('DeviceDailyBills', function() {
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
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [],
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
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100, locker: 1}),
                update: cashAccountUpdateSpy,
            },
            DevicePrePaid: {
                create: devicePrePaidCreateSpy,
            },
            PrePaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
            ...fixedMock,
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            cashAccountUpdateSpy.should.have.been.called;
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
    it('should generate for multiple devices in a single room', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [],
                            prices: [
                                {
                                    type: 'ELECTRIC',
                                    price: 120,
                                }],
                            rooms: [
                                {
                                    id: 3322,
                                    devices: [
                                        {
                                            deviceId: 4444,
                                        },
                                        {
                                            deviceId: 4445,
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
                    }, {
                        toJSON: () => ({
                            deviceId: 4445,
                            startScale: 4.567,
                            endScale: 8.987,
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
                                }, {
                                    deviceId: 4445,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33221,
                    }],
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
            ...fixedMock,
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -39960,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 4560000,
                    type: 'ELECTRICITY',
                    usage: 3330000,
                });
            devicePrePaidCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    amount: -530.4,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4445,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 89870,
                    type: 'ELECTRICITY',
                    usage: 44200,
                });
            prePaidFlowsCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    category: 'device',
                    contractId: 443,
                    id: 444222,
                    paymentDay: 2018,
                    projectId: 1,
                });
            prePaidFlowsCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    category: 'device',
                    contractId: 443,
                    id: 444222,
                    paymentDay: 2018,
                    projectId: 1,
                });
        });
    });
    it('should not ignore 0 amount bills', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();

        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [],
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
                            endScale: 123,
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
            ...fixedMock,
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 10000,
                    projectId: 1,
                    scale: 1230000,
                    type: 'ELECTRICITY',
                    usage: 0,
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
    it('should not ignore bills if no heartbeats at all', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();

        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [],
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
                findAll: async () => [],
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
            ...fixedMock,
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 10000,
                    projectId: 1,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
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
    it('should share public meter', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [
                                {
                                    deviceId: 1119,
                                }],
                            prices: [
                                {
                                    type: 'ELECTRIC',
                                    price: 1000,
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
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    contractId: 1443,
                                    userId: 33222,
                                }],
                        }),
                    }],
            },
            DeviceHeartbeats: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            deviceId: 4444,
                            startScale: 0,
                            endScale: 0,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 4445,
                            startScale: 100,
                            endScale: 100,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 1119,
                            startScale: 0,
                            endScale: 10,
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
                    },
                    {
                        id: 1443,
                        roomId: 3323,
                        room: {
                            id: 3323,
                            houseId: 1,
                            devices: [
                                {
                                    deviceId: 4445,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33222,
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrePaid: {
                create: devicePrePaidCreateSpy,
            },
            PrePaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
            ...fixedMock,
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -5000,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 50,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    amount: -5000,
                    contractId: 1443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 50,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(2).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(3).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 1443,
                    createdAt: 2018,
                    deviceId: 4445,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 1000000,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
        });

    });
    it('should deal customised shared public meter', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [
                                {
                                    deviceId: 1119,
                                }],
                            prices: [
                                {
                                    type: 'ELECTRIC',
                                    price: 1000,
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
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    contractId: 1443,
                                    userId: 33222,
                                }],
                        }),
                    }],
            },
            DeviceHeartbeats: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            deviceId: 4444,
                            startScale: 0,
                            endScale: 0,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 4445,
                            startScale: 100,
                            endScale: 100,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 1119,
                            startScale: 0,
                            endScale: 10,
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
                                }, {
                                    deviceId: 4445,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33221,
                    },
                    {
                        id: 1443,
                        roomId: 3323,
                        room: {
                            id: 3323,
                            houseId: 1,
                            devices: [
                                {
                                    deviceId: 4445,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33222,
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrePaid: {
                create: devicePrePaidCreateSpy,
            },
            PrePaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
            ...fixedMock,
            HouseApportionment: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            houseId: 1,
                            roomId: 3322,
                            value: 30,
                        }),
                    }, {
                        toJSON: () => ({
                            houseId: 1,
                            roomId: 3323,
                            value: 70,
                        }),
                    }],
            },
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -3000,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 30,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    amount: -7000,
                    contractId: 1443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 70,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(2).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(3).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 1443,
                    createdAt: 2018,
                    deviceId: 4445,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 1000000,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
        });

    });
    it('should always share with 100%', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            id: 1,
                            devices: [
                                {
                                    deviceId: 1119,
                                }],
                            prices: [
                                {
                                    type: 'ELECTRIC',
                                    price: 1000,
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
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    contractId: 1443,
                                    userId: 33222,
                                },
                                {
                                    id: 3324,
                                    devices: [
                                        {
                                            deviceId: 4446,
                                        },
                                    ],
                                    contractId: 2443,
                                    userId: 33223,
                                }],
                        }),
                    }],
            },
            DeviceHeartbeats: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            deviceId: 4444,
                            startScale: 0,
                            endScale: 0,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 4445,
                            startScale: 100,
                            endScale: 100,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 1119,
                            startScale: 0,
                            endScale: 10,
                        }),
                    }, {
                        toJSON: () => ({
                            deviceId: 4446,
                            startScale: 200,
                            endScale: 200,
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
                                }
                            ],
                        },
                        expenses: [],
                        userId: 33221,
                    }, {
                        id: 1443,
                        roomId: 3323,
                        room: {
                            id: 3323,
                            houseId: 1,
                            devices: [
                                {
                                    deviceId: 4445,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33222,
                    }, {
                        id: 2443,
                        roomId: 3324,
                        room: {
                            id: 3324,
                            houseId: 1,
                            devices: [
                                {
                                    deviceId: 4446,
                                },
                            ],
                        },
                        expenses: [],
                        userId: 33223,
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrePaid: {
                create: devicePrePaidCreateSpy,
            },
            PrePaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
            ...fixedMock,
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -3400,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 34,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    amount: -3300,
                    contractId: 1443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 33,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(2).args[0].should.be.eql(
                {
                    amount: -3300,
                    contractId: 2443,
                    createdAt: 2018,
                    deviceId: 1119,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 100000,
                    share: 33,
                    type: 'ELECTRICITY',
                    usage: 100000,
                });
            devicePrePaidCreateSpy.getCall(3).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 443,
                    createdAt: 2018,
                    deviceId: 4444,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(4).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 1443,
                    createdAt: 2018,
                    deviceId: 4445,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 1000000,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(5).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: 2443,
                    createdAt: 2018,
                    deviceId: 4446,
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 1000,
                    projectId: 1,
                    scale: 2000000,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
        });


    });
    it('should handle pay exception', async () => {
    });
    it('should handle changing price ???', async () => {
    });
});