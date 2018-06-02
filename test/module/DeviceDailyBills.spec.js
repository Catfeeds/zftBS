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
            ...fixedMock,
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
                                    houseId: 1,
                                    devices: [
                                        {
                                            deviceId: 4444,
                                        },
                                    ],
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
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100, locker: 1}),
                update: cashAccountUpdateSpy,
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
                    balance: -3329900,
                    amount: -3330000,
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
            ...fixedMock,
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
                                    houseId: 1,
                                    devices: [
                                        {
                                            deviceId: 4444,
                                        },
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
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
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: async () => [{id: 123}],
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
                    balance: -39860,
                    amount: -39960,
                });
            prePaidFlowsCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    category: 'device',
                    contractId: 443,
                    id: 444222,
                    paymentDay: 2018,
                    projectId: 1,
                    balance: -430.4,
                    amount: -530.4,
                });
        });
    });
    it('should not ignore 0 amount bills', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();

        global.MySQL = {
            ...fixedMock,
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
                                    houseId: 1,
                                    devices: [
                                        {
                                            deviceId: 4444,
                                        },
                                    ],
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
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: async () => [{id: 123}],
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
                    amount: -0,
                    balance: 100,
                });
        });
    });
    it('should not ignore bills if no heartbeats at all', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();

        global.MySQL = {
            ...fixedMock,
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
                                    houseId: 1,
                                    devices: [
                                        {
                                            deviceId: 4444,
                                        },
                                    ],
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
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: async () => [{id: 123}],
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
                    amount: -0,
                    balance: 100,
                });
        });
    });
    it('should not ignore sharing bills if no heartbeats for public meter at all',
        async () => {
            const devicePrePaidCreateSpy = spy();
            const prePaidFlowsCreateSpy = spy();
            const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

            global.MySQL = {
                ...fixedMock,
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
                                        houseId: 1,
                                    },
                                    {
                                        id: 3323,
                                        devices: [
                                            {
                                                deviceId: 4445,
                                            },
                                        ],
                                        houseId: 1,
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
                            toJSON: () => ({
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
                            }),
                        },
                        {
                            toJSON: () => ({
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
                                houseId: 1,
                            }),
                        }],
                },
                CashAccount: {
                    findOne: async () => ({id: 123, balance: 100}),
                    update: cashAccountUpdateSpy,
                },
                DevicePrepaid: {
                    create: devicePrePaidCreateSpy,
                },
                PrepaidFlows: {
                    create: prePaidFlowsCreateSpy,
                },
            };

            await bill(moment()).then(() => {
                devicePrePaidCreateSpy.should.have.been.called;
                prePaidFlowsCreateSpy.should.have.been.called;
                devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                    {
                        amount: -0,
                        contractId: 443,
                        createdAt: 2018,
                        deviceId: 1119,
                        flowId: 444222,
                        id: 444222,
                        paymentDay: 2018,
                        price: 1000,
                        projectId: 1,
                        scale: 0,
                        share: 50,
                        type: 'ELECTRICITY',
                        usage: 0,
                    });
                devicePrePaidCreateSpy.getCall(1).args[0].should.be.eql(
                    {
                        amount: -0,
                        contractId: 1443,
                        createdAt: 2018,
                        deviceId: 1119,
                        flowId: 444222,
                        id: 444222,
                        paymentDay: 2018,
                        price: 1000,
                        projectId: 1,
                        scale: 0,
                        share: 50,
                        type: 'ELECTRICITY',
                        usage: 0,
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
                        scale: 0,
                        type: 'ELECTRICITY',
                        usage: 0,
                    });
            });
        });
    it('should share public meter', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            ...fixedMock,
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
                                    houseId: 1,
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    houseId: 1,
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
                        toJSON: () => ({
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
                        }),
                    },
                    {
                        toJSON: () => ({
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
                            houseId: 1,
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
            ...fixedMock,
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
                                    houseId: 1,
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    houseId: 1,
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
                        toJSON: () => ({
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
                        }),
                    },
                    {
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
            ...fixedMock,
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
                                    houseId: 1,
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    houseId: 1,
                                },
                                {
                                    id: 3324,
                                    devices: [
                                        {
                                            deviceId: 4446,
                                        },
                                    ],
                                    houseId: 1,
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
                        toJSON: () => ({
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
                        }),
                    }, {
                        toJSON: () => ({
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
                        }),
                    }, {
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
    it('should only share between contracted rooms', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            ...fixedMock,
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
                                    houseId: 1,
                                },
                                {
                                    id: 3323,
                                    devices: [
                                        {
                                            deviceId: 4445,
                                        },
                                    ],
                                    houseId: 1,
                                },
                                {
                                    id: 3324,
                                    devices: [
                                        {
                                            deviceId: 4446,
                                        },
                                    ],
                                    houseId: 1,
                                }],
                        }),
                    }],
            },
            DeviceHeartbeats: {
                findAll: async () => [
                    {
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
                        toJSON: () => ({
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
                        }),
                    }, {
                        toJSON: () => ({
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
                        }),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
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
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
        });

    });
    it('should share with contracted room which even has no device',
        async () => {
            const devicePrePaidCreateSpy = spy();
            const prePaidFlowsCreateSpy = spy();
            const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

            global.MySQL = {
                ...fixedMock,
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
                                        houseId: 1,
                                    },
                                    {
                                        id: 3323,
                                        devices: [
                                            {
                                                deviceId: 4445,
                                            },
                                        ],
                                        houseId: 1,
                                    },
                                    {
                                        id: 3324,
                                        houseId: 1,
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
                            toJSON: () => ({
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
                            }),
                        }, {
                            toJSON: () => ({
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
                            }),
                        }, {
                            toJSON: () => ({
                                id: 2443,
                                roomId: 3324,
                                room: {
                                    id: 3324,
                                    houseId: 1,
                                    devices: [],
                                },
                                expenses: [],
                                userId: 33223,
                            }),
                        }],
                },
                CashAccount: {
                    findOne: async () => ({id: 123, balance: 100}),
                    update: cashAccountUpdateSpy,
                },
                DevicePrepaid: {
                    create: devicePrePaidCreateSpy,
                },
                PrepaidFlows: {
                    create: prePaidFlowsCreateSpy,
                },
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
            });

        });

    it('should handle real data', async () => {
        const devicePrePaidCreateSpy = spy();
        const prePaidFlowsCreateSpy = spy();
        const cashAccountUpdateSpy = stub().resolves([{id: 123}]);

        global.MySQL = {
            ...fixedMock,
            Houses: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            'config': null,
                            'id': '6403211810681524224',
                            'houseFormat': 'SHARE',
                            'projectId': '6376305154160988160',
                            'buildingId': '6403211810668941312',
                            'code': '20180518',
                            'layoutId': 0,
                            'roomNumber': '3',
                            'currentFloor': 3,
                            'houseKeeper': 15,
                            'desc': '',
                            'status': 'OPEN',
                            'createdAt': 1526644661,
                            'deleteAt': 0,
                            'BuildingId': '6403211810668941312',
                            'prices': [
                                {
                                    'houseId': '6403211810681524224',
                                    'category': 'CLIENT',
                                    'type': 'ELECTRIC',
                                    'price': 120,
                                },
                                {
                                    'houseId': '6403211810681524224',
                                    'category': 'CLIENT',
                                    'type': 'ELECTRIC',
                                    'price': 100000,
                                },
                            ],
                            'devices': [
                                {
                                    'deviceId': 'YTL043000101519',
                                    'startDate': 1526645811,
                                    'endDate': 0,
                                    'public': true,
                                },
                            ],
                            'rooms': [
                                {
                                    'config': null,
                                    'id': '6403211810685718529',
                                    'houseId': '6403211810681524224',
                                    'name': 'A',
                                    'people': 0,
                                    'type': '',
                                    'roomArea': 0,
                                    'orientation': 'N',
                                    'createdAt': '1970-01-18T16:04:04.000Z',
                                    'updatedAt': '2018-05-18T11:57:41.000Z',
                                    'deletedAt': null,
                                    'HouseId': '6403211810681524224',
                                    'devices': [
                                        {
                                            'id': 2341,
                                            'projectId': '6376305154160988160',
                                            'sourceId': '6403211810685718529',
                                            'deviceId': 'YTL043000101493',
                                            'startDate': 1526645800,
                                            'endDate': 1526692393,
                                            'public': false,
                                            'createdAt': '2018-05-18T12:16:40.000Z',
                                            'updatedAt': '2018-05-19T01:13:13.000Z',
                                            'deletedAt': null,
                                        },
                                        {
                                            'id': 2343,
                                            'projectId': '6376305154160988160',
                                            'sourceId': '6403211810685718529',
                                            'deviceId': 'YTL043000101493',
                                            'startDate': 1526692401,
                                            'endDate': 0,
                                            'public': false,
                                            'createdAt': '2018-05-19T01:13:21.000Z',
                                            'updatedAt': '2018-05-19T01:13:21.000Z',
                                            'deletedAt': null,
                                        },
                                        {
                                            'id': 2344,
                                            'projectId': '6376305154160988160',
                                            'sourceId': '6403211810685718529',
                                            'deviceId': 'YTL043000101477',
                                            'startDate': 1526692406,
                                            'endDate': 1527049490,
                                            'public': false,
                                            'createdAt': '2018-05-19T01:13:26.000Z',
                                            'updatedAt': '2018-05-23T04:24:50.000Z',
                                            'deletedAt': null,
                                        },
                                        {
                                            'id': 2345,
                                            'projectId': '6376305154160988160',
                                            'sourceId': '6403211810685718529',
                                            'deviceId': 'YTL043000101501',
                                            'startDate': 1526692414,
                                            'endDate': 1527049492,
                                            'public': false,
                                            'createdAt': '2018-05-19T01:13:34.000Z',
                                            'updatedAt': '2018-05-23T04:24:52.000Z',
                                            'deletedAt': null,
                                        },
                                    ],
                                },
                                {
                                    'config': null,
                                    'id': '6403211810685718530',
                                    'houseId': '6403211810681524224',
                                    'name': 'B',
                                    'people': 0,
                                    'type': '',
                                    'roomArea': 0,
                                    'orientation': 'N',
                                    'createdAt': '1970-01-18T16:04:04.000Z',
                                    'updatedAt': '2018-05-18T11:57:41.000Z',
                                    'deletedAt': null,
                                    'HouseId': '6403211810681524224',
                                    'devices': [
                                        {
                                            'id': 2346,
                                            'projectId': '6376305154160988160',
                                            'sourceId': '6403211810685718530',
                                            'deviceId': 'YTL043000101501',
                                            'startDate': 1527602294,
                                            'endDate': 0,
                                            'public': false,
                                            'createdAt': '2018-05-29T13:58:14.000Z',
                                            'updatedAt': '2018-05-29T13:58:14.000Z',
                                            'deletedAt': null,
                                        },
                                    ],
                                },
                                {
                                    'config': null,
                                    'id': '6404147530237612032',
                                    'houseId': '6403211810681524224',
                                    'name': '3',
                                    'people': 0,
                                    'type': '',
                                    'roomArea': 0,
                                    'orientation': 'N',
                                    'createdAt': '2018-05-21T01:55:54.000Z',
                                    'updatedAt': '2018-05-21T01:55:54.000Z',
                                    'deletedAt': null,
                                    'HouseId': '6403211810681524224',
                                    'devices': [
                                        {
                                            'id': 2347,
                                            'projectId': '6376305154160988160',
                                            'sourceId': '6404147530237612032',
                                            'deviceId': 'YTL043000101477',
                                            'startDate': 1527602512,
                                            'endDate': 0,
                                            'public': false,
                                            'createdAt': '2018-05-29T14:01:52.000Z',
                                            'updatedAt': '2018-05-29T14:01:52.000Z',
                                            'deletedAt': null,
                                        },
                                    ],
                                },
                            ],
                        }),
                    },
                    {
                        toJSON: () => ({
                            'config': null,
                            'id': '6404147798916337664',
                            'houseFormat': 'SHARE',
                            'projectId': '6376305154160988160',
                            'buildingId': '6404147798899560448',
                            'code': '123',
                            'layoutId': 0,
                            'roomNumber': '1',
                            'currentFloor': 12,
                            'houseKeeper': 15,
                            'desc': '',
                            'status': 'OPEN',
                            'createdAt': 1526867818,
                            'deleteAt': 0,
                            'BuildingId': '6404147798899560448',
                            'prices': [
                                {
                                    'houseId': '6404147798916337664',
                                    'category': 'CLIENT',
                                    'type': 'ELECTRIC',
                                    'price': 100000,
                                },
                            ],
                            'devices': [],
                            'rooms': [
                                {
                                    'config': null,
                                    'id': '6404147798916337666',
                                    'houseId': '6404147798916337664',
                                    'name': 'A',
                                    'people': 0,
                                    'type': '',
                                    'roomArea': 0,
                                    'orientation': 'N',
                                    'createdAt': '1970-01-18T16:07:47.000Z',
                                    'updatedAt': '2018-05-21T01:56:58.000Z',
                                    'deletedAt': null,
                                    'HouseId': '6404147798916337664',
                                    'devices': [],
                                },
                                {
                                    'config': null,
                                    'id': '6404147798916337667',
                                    'houseId': '6404147798916337664',
                                    'name': 'B',
                                    'people': 0,
                                    'type': '',
                                    'roomArea': 0,
                                    'orientation': 'N',
                                    'createdAt': '1970-01-18T16:07:47.000Z',
                                    'updatedAt': '2018-05-21T01:56:58.000Z',
                                    'deletedAt': null,
                                    'HouseId': '6404147798916337664',
                                    'devices': [],
                                },
                            ],
                        }),
                    }, {
                        toJSON: () => ({
                            'config': null,
                            'id': '6404215007512498176',
                            'houseFormat': 'SOLE',
                            'projectId': '6376305154160988160',
                            'buildingId': '6404215007499915264',
                            'code': '2101',
                            'layoutId': 0,
                            'roomNumber': '1',
                            'currentFloor': 1,
                            'houseKeeper': 15,
                            'desc': '',
                            'status': 'OPEN',
                            'createdAt': 1526883842,
                            'deleteAt': 0,
                            'BuildingId': '6404215007499915264',
                            'prices': [],
                            'devices': [],
                            'rooms': [
                                {
                                    'config': null,
                                    'id': '6404215007512498178',
                                    'houseId': '6404215007512498176',
                                    'name': 'A',
                                    'people': 0,
                                    'type': '',
                                    'roomArea': 0,
                                    'orientation': 'N',
                                    'createdAt': '1970-01-18T16:08:03.000Z',
                                    'updatedAt': '2018-05-21T06:24:02.000Z',
                                    'deletedAt': null,
                                    'HouseId': '6404215007512498176',
                                    'devices': [],
                                },
                            ],
                        }
                        ),
                    }],
            },
            DeviceHeartbeats: {
                findAll: async () => [],
            },
            Contracts: {
                findAll: async () => [
                    {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [
                                {
                                    'rent': 120,
                                    'configId': 1041,
                                    'pattern': 'prepaid',
                                },
                                {
                                    'rent': 100,
                                    'configId': 1043,
                                    'pattern': 'prepaid',
                                    'frequency': 'day',
                                },
                            ],
                            'id': '6403212239540719616',
                            'roomId': '6403211810685718529',
                            'userId': '6403212239486193664',
                            'room': {
                                'config': null,
                                'id': '6403211810685718529',
                                'houseId': '6403211810681524224',
                                'name': 'A',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '1970-01-18T16:04:04.000Z',
                                'updatedAt': '2018-05-18T11:57:41.000Z',
                                'deletedAt': null,
                                'HouseId': '6403211810681524224',
                                'devices': [
                                    {
                                        'id': 2343,
                                        'projectId': '6376305154160988160',
                                        'sourceId': '6403211810685718529',
                                        'deviceId': 'YTL043000101493',
                                        'startDate': 1526692401,
                                        'endDate': 0,
                                        'public': false,
                                        'createdAt': '2018-05-19T01:13:21.000Z',
                                        'updatedAt': '2018-05-19T01:13:21.000Z',
                                        'deletedAt': null,
                                    },
                                ],
                            },
                        }),
                    },
                    {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [
                                {
                                    'rent': 100,
                                    'configId': 1043,
                                    'pattern': 'prepaid',
                                },
                                {
                                    'rent': 150,
                                    'configId': 1051,
                                    'pattern': 'prepaid',
                                },
                            ],
                            'id': '6407228351379017728',
                            'roomId': '6403211810685718530',
                            'userId': '6407228351299325952',
                            'room': {
                                'config': null,
                                'id': '6403211810685718530',
                                'houseId': '6403211810681524224',
                                'name': 'B',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '1970-01-18T16:04:04.000Z',
                                'updatedAt': '2018-05-18T11:57:41.000Z',
                                'deletedAt': null,
                                'HouseId': '6403211810681524224',
                                'devices': [
                                    {
                                        'id': 2346,
                                        'projectId': '6376305154160988160',
                                        'sourceId': '6403211810685718530',
                                        'deviceId': 'YTL043000101501',
                                        'startDate': 1527602294,
                                        'endDate': 0,
                                        'public': false,
                                        'createdAt': '2018-05-29T13:58:14.000Z',
                                        'updatedAt': '2018-05-29T13:58:14.000Z',
                                        'deletedAt': null,
                                    },
                                ],
                            },
                        }),
                    }, {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [
                                {
                                    'rent': 100,
                                    'configId': 1043,
                                    'pattern': 'prepaid',
                                },
                                {
                                    'rent': 150,
                                    'configId': 1044,
                                    'pattern': 'prepaid',
                                },
                                {
                                    'rent': 200,
                                    'configId': 1047,
                                    'pattern': 'prepaid',
                                },
                                {
                                    'rent': 100,
                                    'configId': 1049,
                                    'pattern': 'prepaid',
                                },
                            ],
                            'id': '6407229204634669056',
                            'roomId': '6404147530237612032',
                            'userId': '6407229204567560192',
                            'room': {
                                'config': null,
                                'id': '6404147530237612032',
                                'houseId': '6403211810681524224',
                                'name': '3',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '2018-05-21T01:55:54.000Z',
                                'updatedAt': '2018-05-21T01:55:54.000Z',
                                'deletedAt': null,
                                'HouseId': '6403211810681524224',
                                'devices': [
                                    {
                                        'id': 2347,
                                        'projectId': '6376305154160988160',
                                        'sourceId': '6404147530237612032',
                                        'deviceId': 'YTL043000101477',
                                        'startDate': 1527602512,
                                        'endDate': 0,
                                        'public': false,
                                        'createdAt': '2018-05-29T14:01:52.000Z',
                                        'updatedAt': '2018-05-29T14:01:52.000Z',
                                        'deletedAt': null,
                                    },
                                ],
                            },
                        }),
                    }, {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [
                                {
                                    'rent': 10000,
                                    'configId': 1043,
                                    'pattern': 'withRent',
                                },
                            ],
                            'id': '6408158898410360832',
                            'roomId': '6404215007512498178',
                            'userId': '6408158898305503232',
                            'room': {
                                'config': null,
                                'id': '6404215007512498178',
                                'houseId': '6404215007512498176',
                                'name': 'A',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '1970-01-18T16:08:03.000Z',
                                'updatedAt': '2018-05-21T06:24:02.000Z',
                                'deletedAt': null,
                                'HouseId': '6404215007512498176',
                                'devices': [],
                            },
                        }),
                    }, {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [
                                {
                                    'rent': 900,
                                    'configId': 1043,
                                    'pattern': 'withRent',
                                },
                            ],
                            'id': '6408159540944179200',
                            'roomId': '6404147798916337666',
                            'userId': '6408159540881264640',
                            'room': {
                                'config': null,
                                'id': '6404147798916337666',
                                'houseId': '6404147798916337664',
                                'name': 'A',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '1970-01-18T16:07:47.000Z',
                                'updatedAt': '2018-05-21T01:56:58.000Z',
                                'deletedAt': null,
                                'HouseId': '6404147798916337664',
                                'devices': [],
                            },
                        }),
                    }, {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [
                                {
                                    'rent': 2200,
                                    'configId': 1043,
                                    'pattern': 'withRent',
                                },
                            ],
                            'id': '6408165370619891712',
                            'roomId': '6404147798916337667',
                            'userId': '6408165370515034112',
                            'room': {
                                'config': null,
                                'id': '6404147798916337667',
                                'houseId': '6404147798916337664',
                                'name': 'B',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '1970-01-18T16:07:47.000Z',
                                'updatedAt': '2018-05-21T01:56:58.000Z',
                                'deletedAt': null,
                                'HouseId': '6404147798916337664',
                                'devices': [],
                            },
                        }),
                    }, {
                        toJSON: () => ({
                            'strategy': {},
                            'expenses': [],
                            'id': '6408244767330799616',
                            'roomId': '6404147798916337667',
                            'userId': '6408244767238524928',
                            'room': {
                                'config': null,
                                'id': '6404147798916337667',
                                'houseId': '6404147798916337664',
                                'name': 'B',
                                'people': 0,
                                'type': '',
                                'roomArea': 0,
                                'orientation': 'N',
                                'createdAt': '1970-01-18T16:07:47.000Z',
                                'updatedAt': '2018-05-21T01:56:58.000Z',
                                'deletedAt': null,
                                'HouseId': '6404147798916337664',
                                'devices': [],
                            },
                        }
                        ),
                    }],
            },
            CashAccount: {
                findOne: async () => ({id: 123, balance: 100}),
                update: cashAccountUpdateSpy,
            },
            DevicePrepaid: {
                create: devicePrePaidCreateSpy,
            },
            PrepaidFlows: {
                create: prePaidFlowsCreateSpy,
            },
        };

        await bill(moment()).then(() => {
            devicePrePaidCreateSpy.should.have.been.called;
            prePaidFlowsCreateSpy.should.have.been.called;
            devicePrePaidCreateSpy.getCall(0).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: '6403212239540719616',
                    createdAt: 2018,
                    deviceId: 'YTL043000101519',
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 0,
                    share: 34,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(1).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: '6407228351379017728',
                    createdAt: 2018,
                    deviceId: 'YTL043000101519',
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 0,
                    share: 33,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(2).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: '6407229204634669056',
                    createdAt: 2018,
                    deviceId: 'YTL043000101519',
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    share: 33,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(3).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: '6403212239540719616',
                    createdAt: 2018,
                    deviceId: 'YTL043000101493',
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(4).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: '6407228351379017728',
                    createdAt: 2018,
                    deviceId: 'YTL043000101501',
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 0,
                    type: 'ELECTRICITY',
                    usage: 0,
                });
            devicePrePaidCreateSpy.getCall(5).args[0].should.be.eql(
                {
                    amount: -0,
                    contractId: '6407229204634669056',
                    createdAt: 2018,
                    deviceId: 'YTL043000101477',
                    flowId: 444222,
                    id: 444222,
                    paymentDay: 2018,
                    price: 120,
                    projectId: 1,
                    scale: 0,
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