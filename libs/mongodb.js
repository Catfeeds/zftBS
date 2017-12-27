const mongo = require('mongoose');
const config = require('config');
const moment = require('moment');
const _ = require('underscore');
const Schema = mongo.Schema;
const ObjectId = Schema.ObjectId;
const Q = require('q');

mongo.Promise = global.Promise;

exports = module.exports = function(url) {
    return new Promise((resolve, reject)=>{
        var dbURL;
        if(!url){
            dbURL = config.MongoDB.url;
        }
        else {
            dbURL = url;
        }

        mongo.Promise = global.Promise;
        let options = {

        };
        mongo.connect(dbURL, options).then(
            ()=>{
                log.info('mongoose connect ['+dbURL+'] successful');
                resolve();
            },
            (err)=>{
                log.error(err);
                reject(err);
            }
        );
    });
};

exports.UpdateBuild = function(queryoperate)
{
    var updateObj = {};
    if(!queryoperate){
        return null;
    }
    _.map(queryoperate, function(v, k){
        updateObj['$'+k] = v;
    });
    return updateObj;
};

exports.MiddleWare = function(schema)
{
    var mongoMiddleware = schema;
    this.where = function(queryFactor){
        mongoMiddleware = mongoMiddleware.where(queryFactor);
        return mongoMiddleware;
    };
    this.or = function (queryFactor) {
        mongoMiddleware = mongoMiddleware.or(queryFactor);
        return mongoMiddleware;
    };
    this.in = function (queryFactor){
        mongoMiddleware = mongoMiddleware.in(queryFactor);
        return mongoMiddleware;
    };
    this.find = function (queryFactor){
        mongoMiddleware = mongoMiddleware.find(queryFactor);
        return mongoMiddleware;
    };
    this.findOne = function(queryFactor){
        mongoMiddleware = mongoMiddleware.findOne(queryFactor);
        return mongoMiddleware;
    };
    this.populate = function(queryFactor){
        mongoMiddleware = mongoMiddleware.populate(queryFactor);
        return mongoMiddleware;
    };
    this.exec = function(callback){
        mongoMiddleware = mongoMiddleware.exec(callback);
        return mongoMiddleware;
    };
    this.gt = function(callback){
        mongoMiddleware = mongoMiddleware.gt(callback);
        return mongoMiddleware;
    };
    this.gte = function(callback){
        mongoMiddleware = mongoMiddleware.gte(callback);
        return mongoMiddleware;
    };
    this.lt = function(callback){
        mongoMiddleware = mongoMiddleware.lt(callback);
        return mongoMiddleware;
    };
    this.lte = function(callback){
        mongoMiddleware = mongoMiddleware.lte(callback);
        return mongoMiddleware;
    };
    this.equals = function(callback){
        mongoMiddleware = mongoMiddleware.equals(callback);
        return mongoMiddleware;
    };
    this.sort = function(callback){
        mongoMiddleware = mongoMiddleware.sort(callback);
        return mongoMiddleware;
    };
    this.exists = function(callback){
        mongoMiddleware = mongoMiddleware.exists(callback);
        return mongoMiddleware;
    };
};
//能耗分类 DEPRECATED
exports.energyCategorySchema = new Schema({
    _id: String,
    title: String,
    unit: String,
    standcol: Number,
    description: String,
    devicetype: String
});
//项目
exports.projectSchema = new Schema({
    title:{
        type: String,
        require: true
    },
    // billingAccount:{
    //     type: ObjectId,
    //     ref: 'billingAccount'
    // },
    enterprise: String, //公司名
    description: String,
    level: Number,
    energy: Schema.Types.Mixed,
    onduty: String,
    offduty: String,
    billingtime: Number,
    billingservice: {
        type: Boolean,
        default: true
    },
    timecreate: Number,
    status: {
        type: String,
        default: 'ONLINE'
    }, // debug,online,pending
    smstag: String,
    attrib: String, //项目属性
    address: String,    //项目地址
    avatar: String, //项目图片
    payment: {  //是否使用支付
        type: Boolean,
        defaultValue: false
    },
    prepayment: { //是否预付费
        type: Boolean,
        defaultValue: false
    },
    epayment: { //是否电子支付
        type: Boolean,
        defaultValue: false
    },
    thirdpartbill: {    //第三方账单 CLOSE/PRE/BILL
        type: String,
        defaultValue: false
    },
    app: Schema.Types.Mixed, //app渠道启用列表
    sector: String,         //项目行业
    source: String,          //项目来源
    withdraw: Schema.Types.Mixed,   //提现属性,
    alipay_life: Schema.Types.Mixed,
    alipay_tenement: Schema.Types.Mixed,
});
//路径请求
exports.urlPathSchema = new Schema({
    _id: String,
    enable: {
        type: Boolean,
        default: true
    },
    needlogin:{
        type: Boolean,
        default: true
    },
    authtype: {
        type: String,
        require: true,
        default: 'NONE' //NONE/BYACCOUNT/BYAPPID
    },
    inproject:{ //是否在项目权限中启用
        type: Boolean,
        default: false
    },
    desc:{
        type: String
    }
});
exports.resourceSchema = new Schema({
    key: {
        type: String,
        require: true
    },
    value: String,
    begin: {
        type: Date,
        require: true,
        default: Date.now
    },
    end: {
        type: Date,
        require: true,
        default: Date.now
    },
    belongto: {
        type: String,
        require: true,
        ref: 'account'
    },
    type: String,
    desc: String
});
//账户 DEPRECATED
// exports.accountSchema = new Schema({
//     _id: {
//         type: String,
//         require: true
//     },
//     passwd: {
//         type: String
//     },
//     //控制密码
//     ctrlpasswd: {
//         type: String,
//         require: true,
//         default:'123456'
//     },
//     title:{
//         type: String
//     },
//     lastlogin: {
//         type: Date,
//         require: true,
//         default: Date.now
//     },
//     applastlogin:{
//         type: Number,
//         default: 0
//     },
//     initpath: {
//         type: String
//     },
//     character:{
//         type: String,
//         require: true,
//         ref: 'character'
//     },
//     resource:{
//         type: Schema.Types.Mixed,
//         require: true,
//         default: {}
//     },
//     timedelete: {
//         type: Number
//     },
//     timecreate: {
//         type: Number
//     },
//     timepause: Number,
//     expire: {
//         type: Number,
//         default: 0
//     },
//     token: String,
//     billingAccount:{
//         type: ObjectId,
//         ref: 'billingAccount'
//     },
//     type:{
//         type: String,
//         require: true,
//         default: 'USER' //User/AppID
//     },
//     mobile: String,     //手机号码
//     email: String,      //邮箱
//     message: String     //消息推送权限
// });
//APPID账户
exports.appidsecretSchema = new Schema({
    _id: {
        type: String,
        require: true,
        unique: true
    },
    secret: {
        type: String
    },
    account: {
        type: String,
        ref: "account"
    },
    character:{
        type: Schema.ObjectId,
        require: true,
        ref: 'character'
    },
    resource:{
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    },
    expire: {
        type: Number
    },
    desc: String
});
//角色
exports.characterSchema = new Schema({
    _id:{
        type: String,
        require: true
    },
    title: {
        type: String,
        require: true
    },
    rule:{
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    },
    level: Number,
    maxpower: Number,   //最大权限
    minpower: Number,   //最小权限
    message: String     //消息推送权限
});
//采集器
exports.collectorSchema = new Schema({
    _id:{
        type: String,
        require: true
    },
    title:{
        type: String,
        require: true
    },
    description: String,
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    },
    timecreate: Number,
    floor: Number,
    room: String,
    geolocation: Schema.Types.Mixed,
    ip: String,
    software: String,
    hardware: String,
    status:{    //DEBUG/ONLINE
        type: String,
        default: 'ONLINE'
    },
    lastupdate:{
        type: Number,
        default: 0
    }
});
//传感器
exports.sensorSchema = new Schema({
    //传感器ID
    sid: {
        type: String,
        require: true,
        index: true
    },
    key: {
        type: String,
        require: true,
        index: true
    },
    //传感器标识
    tag: {
        type: String,
        require: true
    },
    //传感器名
    title: {
        type: String,
        require: true
    },
    //传感器描述
    description: {
        type: String,
        default: ''
    },
    //设备类型
    devicetype: {
        type: String
    },
    //项目ID
    project: {
        type: ObjectId,
        require: true,
        ref: "project"
    },
    //建筑ID
    building: {
        type: String,
        require: true
    },
    //社会属性列表
    socity: {
        type: Schema.Types.Mixed,
        ref: 'customer'
    },
    /*
     计费形式
     NONE: 不计费,
     BYSELF: 计费但不公摊
     BYCOUNT: 按用户数公摊
     BYAREA: 按面积公摊
     BYCONSUMPTION: 按能耗公摊
     * */
    paystatus: {
        type: String,
        require: true,
        default: 'NONE'
    },
    //是否屏蔽传感器
    mask: {
        type: Boolean,
        require: true,
        default: false
    },
    //传感器更新频率
    freq: {
        type: Number,
        default: 1800
    },
    //实际更新频率
    realfreq: {
        type: Number,
        default: 0
    },
    //最近一次刻度
    lasttotal: {
        type: Number,
        require: true,
        default: 0
    },
    //最近一次差值
    lastvalue: {
        type: Number,
        require: true,
        default: 0
    },
    //最近更新时间
    lastupdate: {
        type: Date
    },
    //最近传感器实时读数
    realdata: {
        type: Number,
        require: true,
        default: 0
    },
    //传感器能耗分类
    energy: {
        type: String,
        require: true
    },
    //传感器能耗子分类
    energyPath: {
        type: String,
        require: true
    },
    //互感器系数
    comi: {
        type: String,
        require: true,
        default: 'd*1'
    },
    comport: {
        type: String
    },
    timedelete: {
        type: Number
    },
    timecreate: {
        type: Number
    },
    code: {
        type: String,
        default: ''
    },
    subentry: {
        type: String,
        default: ''
    }
});
//社会属性
exports.customerSchema = new Schema({
    socities:{
        type: Schema.Types.Mixed
    },
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    }
});
//建筑 DEPRECATED
// exports.buildingSchema = new Schema({
//     _id: {
//         type: String,
//         require: true
//     },
//     title: String,
//     description: String,
//     acreage: {
//         type: Number,
//         require: true
//     },
//     avgConsumption: Number,
//     totalConsumption: Number,
//     geolocation: Schema.Types.Mixed,
//     project:{
//         type: ObjectId,
//         require: true,
//         ref: "project"
//     }
// });
//户(Department)
exports.departmentSchema = new Schema({
    title: String,
    tag: {
        type: String,
        defaultValue: ''
    },    //商户编号
    resource: Schema.Types.Mixed,
    character: {
        type: String,
        require: true,
        default: 'NONE'
    },
    area: {
        type: Number,
        default: 0
    },
    onduty: String,
    offduty: String,
    account: {
        type: String,
        ref: "account"
    },
    timecreate: Number,
    timedelete:{
        type: Number
    },
    timepause: Number,    //账户停用日期
    building: {
        type: String,
        default: ''
    },
    project: {
        type: ObjectId,
        require: true,
        ref: "project"
    },
    arrearagetime: {
        type: Number,
        default: 0
    },
    remindercount: {
        type: Number,
        require: true,
        default: 0
    },    //催缴次数
    rechargeable:{   //是否允许渠道支付(非人工充值manual)
        type: Boolean,
        default: true
    },
    desc: String
});
//能耗类型
exports.energySchema = new Schema({
    title:{
        type: String,
        require: true
    },
    unitprice:{
        type: Schema.Types.Mixed,
        require: true
    },
    standcol:{
        type: Number,
        default: 0
    },
    description: String,
    childrens: Schema.Types.Mixed
});
//计费账户  DEPRECATED
// exports.billingAccount = new Schema({
//     uid:{
//         type: String,
//         ref: "account"
//     },
//     title: String,
//     cash: { //可用金额
//         type: Number,
//         require: true,
//         default: 0
//     },
//     frozen: {   //冻结金额
//         type: Number,
//         require: true,
//         default: 0
//     },
//     consume: {  //已花费
//         type: Number,
//         require: true,
//         default: 0
//     },
//     expire: {
//         type: Schema.Types.Mixed,
//         require: true,
//         default: 0
//     },
//     alerthreshold:{
//         type: Number,
//         default: 0
//     },
//     timeupdate:{
//         type: Number
//     },
//     timedelete:{
//         type: Number
//     }
// });
//计费服务
exports.billingService = new Schema({
    title: String,
    energycategory: Schema.Types.Mixed, //能耗分类数组
    project: {
        type: ObjectId,
        ref: "project"
    },
    description: String,
    rules: Schema.Types.Mixed   //计费规则
});
//套餐计划
exports.packagePlan = new Schema({
    billingService: {
        type: ObjectId,
        ref: 'billingservice'
    },
    title: String,
    rent: {
        type: Schema.Types.Mixed,
        default: 0
    },
    price: {
        type: Schema.Types.Mixed,
        default: 0
    },
    period: String,
    freq: {
        type: Schema.Types.Mixed,
        default: 0
    },
    pkgtype: String,
    value: {
        type: Schema.Types.Mixed,
        default: 0
    },
    valuetype: String,
    priority: Schema.Types.Mixed
});
//用户套餐
exports.userPackage = new Schema({
    packageplan:{
        type: ObjectId,
        ref: 'packageplan'
    },
    user:{
        type: String,
        ref: 'account'
    },
    value: Schema.Types.Mixed,
    begin: Schema.Types.Mixed,
    end: Schema.Types.Mixed
});

/*
* 渠道充值订单
* */
exports.chargeLogSchema = new Schema({
    //订单号
    orderno: {
        type: String,
        require: true,
        index: true
    },
    uid:{
        type: String,
        require: true,
        ref: 'account'
    },
    project:{
        type: ObjectId,
        require: true,
        ref: "project"
    },
    chargeid: {
        type: String,
        default: null,
        index: true
    },
    transaction:{
        type: String,
        default: null
    },
    //渠道标识
    channel: {
        type: String,
        require: true,
        default: ""
    },
    amount: {
        type: Number,
        require: true,
        default: 0
    },
    subject: String,
    body: String,
    description: String,
    metadata: Schema.Types.Mixed,
    timecreate: {
        type: Date,
        require: true,
        default: Date.now
    },
    timepaid: {
        type: Date,
        require: true,
        default: null
    },
    timereversal:{
        type: Date,
        require: true,
        default: null
    }
});

//每小时/每分钟数据
exports.dataPerClassification = new Schema({
    sensor: {
        type: ObjectId,
        require: true,
        ref: 'sensor',
        index: true
    },
    timepoint: {
        type: Date,
        require: true,
        default: Date.now,
        index: true
    },
    value: {
        type: Schema.Types.Mixed,
        require: true
    },
    total: {
        type: Schema.Types.Mixed,
        require: true
    },
    timeslot: {
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    }
});

exports.dataPerDayWeekMonthYear = new Schema({
    sensor: {
        type: ObjectId,
        require: true,
        ref: 'sensor',
        index: true
    },
    timepoint: {
        type: Date,
        require: true,
        default: Date.now,
        index: true
    },
    value: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0.0
    },
    timeslot: {
        type: Schema.Types.Mixed,
        require: true,
        default: {"0":0, "1":0, "2":0, "3":0, "4":0, "5":0, "6":0, "7":0, "8":0, "9":0, "10":0, "11":0, "12":0, "13":0, "14":0, "15":0, "16":0, "17":0, "18":0, "19":0, "20":0, "21":0, "22":0, "23":0}
    },
    total: {
        type: Schema.Types.Mixed,
        require: true,
        default: 0.0
    }
});

exports.dataPoint = new Schema({
    sensor: {
        type: String,
        require: true,
        ref: 'sensor'
    },
    timestamp: {
        type: Date,
        require: true,
        default: Date.now
    },
    value: {
        type: Schema.Types.Mixed,
        require: true
    },
    total: {
        type: Schema.Types.Mixed,
        require: true
    }
});

/*
    传感器控制信息
    _id: buildingID+gatewayID+meterID(可以唯一表示一台采集器)
    driver: 采集器对应的驱动目录
    project: 项目名称
* */
exports.sensorAttributeSchema = new Schema({
    _id: String,
    project: ObjectId,
    auid: String,   //采集器标识(Application Unique ID)
    addrid: String,     //传感器地址标识
    devicetype: String,   //设备类型
    tag: String,
    title: String,
    comport: Number,
    freq: Number,
    comi: String,
    status: {
        type: Schema.Types.Mixed,
        require: true,
        default: {}
    },
    driver: String,
    dataprotocol: String,
    subentry: String,
    ext: Schema.Types.Mixed,    //传感器扩展属性
    billingservice: Number,
    primary: {
        type: Boolean,
        defaultValue: false,
    },
    lastupdate: {
        type: Number,
        require: true,
        default: Date.now
    }
});

//传感器命令缓存
exports.sensorCommandQueue = new Schema({
    uid:{
        type: String,
        require: true,
        ref: 'account'
    },
    /*
    命令状态标识：
        REQ: 向传感器请求
        REP: 传感器回应
    * */
    status: {
        type:String,
        require: true
    },
    meterid: String,
    buildingid: String,
    gatewayid: String,
    addrid: String,
    command: Schema.Types.Mixed,
    retry: {    //命令重试次数
        type: Number,
        default: 10
    },
    collectorAUID: String,   //采集器标识
    apiAUID: String,    //接口标识
    code: Number,   //命令返回错误码
    reqdata:{
        type: String
    },
    respdata: Schema.Types.Mixed, //命令返回值
    timecreate: {
        type: Number,
        require: true
    },
    //命令被处理的时间
    timeprocess: {
        type: Number,
        require: true,
        default: 0
    },
    //命令返回的时间
    timedone: {
        type: Number,
        require: true,
        default: 0
    }
});

//微信ID==>用户ID
exports.WXOpenIDUserSchema = new Schema({
    _id: String,
    platformid: {
        type: String,
        ref: 'wxplatform'
    },
    user: {
        type: String,
        ref: 'account'
    }
});

//
exports.WXPlatformSchema = new Schema({
    _id: String,
    name: String,
    map: String,
    appid: String,
    appsecret: String
});

//事件规则
exports.eventService = new Schema({
    title: String,
    events: Schema.Types.Mixed, //适用事件
    project: {
        type: ObjectId,
        ref: "project"
    },
    description: String,
    rules: Schema.Types.Mixed   //事件规则
});

//事件日志
exports.eventSchema = new Schema({
    timestamp: Number,
    param: Schema.Types.Mixed,
    type: Number
});

//事件分类(最多15种一级事件)
exports.eventCategorySchema = new Schema({
    _id: String,
    templateid: String,
    title:String,
    subevents: Schema.Types.Mixed
});

exports.userEventCacheSchema = new Schema({
    _id: String,
    balinsufficient: Number,    //余额不足时间
    arrearage: Number,  //欠费时间
    remind: Number //欠费提醒次数
});

exports.ObjectId = ObjectId;
exports.Schema = Schema;
exports.Types = Schema.Types;
exports.Model = mongo.model;
exports.DB = mongo.db;
exports.NewObjectId = function()
{
    return new mongo.Types.ObjectId;
};
exports.IsValidObjectID = function(v)
{
    try {
        var objV = new mongo.Types.ObjectId(v);
    }
    catch(e){
        return false;
    }
    return objV.toString() == v;
};

exports.AllocModel = function (name, schema) {
    return mongo.model(name, schema);
};

exports.Project = mongo.model('project', exports.projectSchema);
exports.EnergyCategory = mongo.model('energycategory', exports.energyCategorySchema);
// exports.Resource = mongo.model('resource', exports.resourceSchema); DEPRECATED
// exports.UrlPath = mongo.model('urlpath', exports.urlPathSchema);
exports.DataBuffer = mongo.model('dataBuffer', exports.dataPoint);
exports.Customer = mongo.model('customer', exports.customerSchema);
exports.Sensor = mongo.model('sensor', exports.sensorSchema);
exports.Collector = mongo.model('collector', exports.collectorSchema);
exports.Energy = mongo.model('energy', exports.energySchema);
exports.EventCategory = mongo.model('eventCategory', exports.eventCategorySchema);
exports.EventService = mongo.model('eventService', exports.eventService);
exports.Event = mongo.model('event', exports.eventSchema);
exports.SensorAttribute = mongo.model('sensorattribute', exports.sensorAttributeSchema);
// exports.SensorCommandQueue = mongo.model('commandQueue', exports.sensorCommandQueue);
exports.UserEventCache = mongo.model('usereventcache', exports.userEventCacheSchema);


// exports.BillingAccount = mongo.model('billingAccount', exports.billingAccount); DEPRECATED
exports.BillingService = mongo.model('billingService', exports.billingService);
exports.PackagePlan = mongo.model('packagePlan', exports.packagePlan);
exports.UserPackage = mongo.model('userpackage', exports.userPackage);
//exports.ChargeLog = mongo.model('chargeLog', exports.chargeLogSchema);

exports.WXOpenIDUser = mongo.model('wxopeniduser', exports.WXOpenIDUserSchema);
exports.WXPlatform = mongo.model('wxplatform', exports.WXPlatformSchema);

exports.CreateModel = function(db, name, schema)
{
    return db.model(name, schema);
};

exports.PERMINUTE = 'PERMINUTE';
exports.PERDAY = 'PERDAY';
exports.PERWEEK = 'PERWEEK';
exports.PERMONTH = 'PERMONTH';
exports.PERYEAR = 'PERYEAR';

var TimeTypeToCollection = {
    'PERMINUTE': {
        name: 'dataperminute',
        timeformat: 'YYYYMM',
        pointformat: 'YYYYMMDD',
        schema: exports.dataPerClassification
    },
    'PERDAY': {
        name: 'dataperday',
        timeformat: 'YYYYMM',
        pointformat: 'YYYYMMDD',
        schema: exports.dataPerDayWeekMonthYear
    },
    'PERWEEK': {
        name: 'dataperweek',
        timeformat: 'YYYY',
        pointformat: 'YYYYWW',
        schema: exports.dataPerDayWeekMonthYear
    },
    'PERMONTH': {
        name: 'datapermonth',
        timeformat: 'YYYY',
        pointformat: 'YYYYMM',
        schema: exports.dataPerDayWeekMonthYear
    },
    'PERYEAR': {
        name: 'dataperyear',
        timeformat: 'YYYY',
        pointformat: 'YYYY',
        schema: exports.dataPerDayWeekMonthYear
    }
};

var SensorCacheSchema = new Schema({
    _id: String,
    data: Schema.Types.Mixed,
    timestamp: Date
});
var CacheCollection = {
    'DAYCACHE': {
        name: 'cache.day.',
        timeformat: 'YYYYMM',
        schema: SensorCacheSchema
    },
    'WEEKCACHE': {
        name: 'cache.week.',
        timeformat: 'YYYY',
        schema: SensorCacheSchema
    },
    'MONTHCACHE': {
        name: 'cache.month.',
        timeformat: 'YYYY',
        schema: SensorCacheSchema
    },
    'YEARCACHE': {
        name: 'cache.year.',
        timeformat: 'YYYY',
        schema: SensorCacheSchema
    }
};

//计费日志
var PaymentLogSchema = new Schema({
    //金额
    amount: {
        type: Number,
        require: true,
        default: 0
    },
    //用户账户名
    account:{
        type: String,
        require: true,
        ref: 'account',
        index: true
    },
    //用户计费账户
    billingAccount: {
        type: Schema.ObjectId,
        require: true,
        ref: "billingaccount",
        index: true
    },
    //计费关联的设备
    deviceid: {
        type: String,
        require: true,
        default: ''
    },
    //计费关联项目
    project: {
        type: ObjectId,
        require: true,
        ref: "project"
    },
    //冲正
    reversal:{
        type: Boolean,
        require: true,
        default: false
    },
    //计费类型
    type:{
        type: String,
        require: true,
        default: ''
    },
    //备注
    remark:{
        type: String
    },
    timestamp: {
        type: Date,
        require: true,
        default: Date.now()
    }
});

exports.DailyData = function()
{
    var collectionName = 'dailyData' + moment().format('YYYYMMDD');
    return mongo.model(collectionName, exports.dataPoint);
};

exports.CollectionByTimeType = function(type, dataTime)
{
    //
    var collection = TimeTypeToCollection[type];
    if(collection == undefined){
        log.debug('Unknow TimeType: ', type);
        return null;
    }
    var timepoint = '';
    if(collection.timeformat.length != 0){
        timepoint = dataTime.format(collection.timeformat);
    }
    var collectionName = collection.name + timepoint;
    //log.debug(type, collectionName);

    timepoint = moment(dataTime).format(collection.pointformat);
    timepoint = moment(timepoint, collection.pointformat).toDate();

    return {
        model: mongo.model(collectionName, collection.schema),
//        timepoint: dataTime.format(collection.pointformat)
        timepoint: timepoint
    }
};

exports.CollectionBySensorCacheType = function(type, dataTime)
{
    //
    var collection = CacheCollection[type];
    if(collection == undefined){
        log.debug('Unknow CacheType: ', type);
        return undefined;
    }
    var collectionName = 'sensor.' + collection.name;
    if(dataTime && collection.timeformat.length != 0){
        //
        collectionName += dataTime.format(collection.timeformat);
    }
    //log.debug(type, collectionName);

    return mongo.model(collectionName, collection.schema);
};

exports.ChargeLogCollection = function()
{
//    var timeQuantum = moment().format('YYYYMM');
    var collectionName = 'chargelog';
    var chargeLogModel = mongo.model(collectionName, exports.chargeLogSchema);
    var chargeLog ={
        schema: chargeLogModel,
        model: new chargeLogModel()
    };
    return chargeLog;
};

/*
* 渠道充值订单collection生成
* */
exports.ChargeLogCollection = function(time)
{
    var collectionName = 'chargelog';
    var chargeLogModel = mongo.model(collectionName, exports.chargeLogSchema);
    var charge={
        schema: chargeLogModel,
        model: new chargeLogModel()
    };
    return charge;
};

exports.PaymentLogCollection = function(logTime)
{
    var PaymentLogCollectionName = 'paymentlog';
    var PaymentLogCollectionTimeFormat = 'YYYYMM';

    var timeQuantum = logTime || moment();


    var collectionName = PaymentLogCollectionName + timeQuantum.format(PaymentLogCollectionTimeFormat);
    var paymentLogModel = mongo.model(collectionName, PaymentLogSchema);

    return {
        schema: paymentLogModel,
        model: new paymentLogModel()
    }
};