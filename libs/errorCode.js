/*
 * 错误码列表
 * */
var _ = require('underscore');

var ErrorCodeList = {
    'OK': 0,

    //系统错误
    'DATABASEEXEC': 90000001,   //数据库执行错误
    'ACCESSDENIED': 90000002,   //拒绝访问(侧重于访问)
    'LOGINWITHOUTPARAM': 90000003,  //登录失败缺少参数
    'PERMISSIONDENIED': 90000004,   //权限不足(侧重于权限)
    'NOTLOGINYET': 90000005,        //未登录
    'AUTHFAILED': 90000006,        //身份验证失败,检查请求的参数
    'SIGNATUREFAILED': 90000007,    //签名校验失败
    'RETRYLATER':           90000008,   //稍后重试
    'NOTSUPPORT':           90000009,   //不支持该项服务
    'AUTHORITYDUMPLICATE':  90000010,   //权限重复
    'LOCKDUMPLICATE':     90000011,   //锁冲突

    //业务错误
    'USERNOTEXISTS':        20000001,   //用户不存在
    'SENSORNOTEXISTS':      20000002,   //传感器不存在
    'PARAMETERMISSED':      20000003,   //参数不全
    'EXCELFORMATERROR':     20000004,   //excel格式错误
    'UPLOADNOTEXISTS':      20000005,   //没有文件上传
    'TIMETYPEERROR':        20000006,   //时间类型错误
    'CHANNELNOTEXISTS':     20000007,   //请求渠道不存在
    'DUPLICATEREQUEST':     20000008,   //重复请求
    'CHANNELIDNOTFOUND':    20000009,   //传感器通道不存在
    'CHANNELCREATEFAILED':  20000010,   //渠道创建错误
    'PAYMENTOBJEMPTY':      20000011,   //支付对象为空
    'REQUESTUNMATCH':       20000012,   //请求无法匹配
    'USEREXISTS':           20000013,   //用户已经存在
    'DEVICETYPEERROR':      20000014,   //仪表类型错误
    'COMIFORMULAERROR':     20000015,   //互感公式错误
    'ENERGYTYPEERROR':      20000016,   //能耗类型错误
    'USERIDTOOSHORT':       20000017,   //用户名长度过短
    'CASHNOTENOUGH':        20000018,   //可用资金不足
    'DEVICEIDERROR':        20000019,   //仪表ID错误
    'UNABLERECHARGE':       20000020,   //该账户不允许充值
    'BUILDFAILED':          20000021,   //生成失败
    'BUILDINGEXISTS':       20000022,   //建筑已经存在
    'SENSORDUMPLICATE':     20000023,   //传感器重复
    'ARREARAGEACCOUNT':     20000024,   //账户已欠款
    'MOBILENOTEXISTS':      20000025,   //手机号码不存在
    'PROJECTNOTEXISTS':     20000026,   //项目不存在
    'CHANNELSETTING':       20000027,   //渠道配置错误
    'BANKNOTSUPPORT':       20000028,   //不支持该银行
    'STRATEGYUNSUPPORT':    20000029,   //策略不支持
    'IMPORTEMPTY':          20000030,   //导入内容为空
    'PARAMETEROVERFLOW':    20000031,   //参数溢出
    'PARAMETERERROR':       20000032,   //参数错误
    'FORMULAERROR':         20000030,   //公式错误

    'CONTRACTWORKING':      21000001,   //合同生效中

    'ORDERTYPENOTALLOWED':  30000001,  //业务类型不允许
    'ORDERNOTEXISTS':       30000002,  //账单不存在
    'ORDERTYPEERROR':       30000003,  //业务类型错误
    'ORDERPAYED':           30000004,  //账单已付款
    'ORDEREXISTS':          30000005,  //账单已创建,等待支付
    'ORDERINVALID':         30000006,  //账单关闭或失效
    'CHARGEINSTINVALID':    30000007,  //出账机构无效

    //设备错误
    'DEVICENOTEXISTS':      60000001,   //仪表未找到
    'SERIALCONFNOTEXISTS':  60000002,   //仪表对应的串口参数未配置
    'DEVICETIMEOUT':        60000003,   //仪表返回超时
    'DRIVERLOADFAILED':     60000004,   //驱动加载失败
    'COMMANDUNSUPPORT':     60000005,   //传感器不支持该命令
    'DATAFORMATERROR':      60000006,   //数据格式错误
    'DATACALIBRATERROR':    60000007,   //数据校验失败
    'CONTROLCODEUNSUPPORT': 60000008,   //传感器不支持该控制码
    'DEVICETYPEUNSUPPORT':  60000009,   //传感器类型不支持
    'CONTROLAUTHFAILED':    60000010,   //控制校验失败
    'PROTOCOLUNSUPPORT':    60000011,   //协议不支持,
    'CHANNELPARAMLACK':     60000012,   //通道参数不足
};

var ErrorMessageList = {
    'OK': '',
    'DATABASEEXEC': '数据库执行错误',
    'ACCESSDENIED': '拒绝访问',
    'USERNOTEXISTS': '用户不存在',
    'LOGINWITHOUTPARAM': '登录失败,缺少参数',
    'PERMISSIONDENIED': '权限不足',
    'NOTLOGINYET': '未登录',
    'AUTHFAILED': '身份验证失败',
    'LOGINFAILED': '身份验证失败',
    'SIGNATUREFAILED': '签名校验失败',
    'RETRYLATER': '稍后重试',
    'NOTSUPPORT': '不支持该项服务',
    'AUTHORITYDUMPLICATE': '权限重复',
    'PARAMETERERROR': '参数错误',
    'LOCKDUMPLICATE': '锁冲突',

    'SENSORNOTEXISTS': '传感器不存在',
    'PARAMETERMISSED': '参数不全',
    'EXCELFORMATERROR': 'Excel格式错误',
    'UPLOADNOTEXISTS': '没有文件上传',
    'TIMETYPEERROR': '时间类型错误',
    'CHANNELNOTEXISTS': '请求支付渠道不存在',
    'DUPLICATEREQUEST': '重复请求',
    'CHANNELIDNOTFOUND': '传感器通道未定义',
    'CHANNELCREATEFAILED': '支付渠道创建失败',
    'PAYMENTOBJEMPTY': '支付对象为空',
    'REQUESTUNMATCH': '请求无法匹配',
    'USEREXISTS': '用户已经存在',
    'DEVICETYPEERROR': '仪表类型错误',
    'COMIFORMULAERROR': '互感公式错误',
    'ENERGYTYPEERROR': '能耗类型错误',
    'USERIDTOOSHORT': '用户名长度过短',
    'CASHNOTENOUGH': '可用资金不足',
    'DEVICEIDERROR': '仪表ID错误',
    'UNABLERECHARGE': '该账户暂停充值',
    'BUILDFAILED': '生成失败',
    'BUILDINGEXISTS': '建筑已经存在',
    'SENSORDUMPLICATE': '传感器重复',
    'ARREARAGEACCOUNT': '账户已欠款',
    'MOBILENOTEXISTS': '手机号码不存在',
    'PROJECTNOTEXISTS': '项目不存在',
    'CHANNELSETTING': '渠道配置错误',
    'BANKNOTSUPPORT': '不支持该银行',
    'STRATEGYUNSUPPORT': '策略不支持',
    'PARAMETEROVERFLOW': '参数溢出',
	'IMPORTEMPTY': '导入内容为空',
    'ORDERTYPENOTALLOWED': '业务类型不允许',
    'ORDERNOTEXISTS': '账单不存在',
    'ORDERTYPEERROR': '业务类型错误',
    'ORDERPAYED': '账单已付款',
    'ORDEREXISTS': '账单已创建,等待支付',
    'ORDERINVALID': '账单关闭或失效',
    'CHARGEINSTINVALID': '出账机构无效',
    'FORMULAERROR': '公式错误',

    'CONTRACTWORKING': '合同生效中',

    'DEVICENOTEXISTS': '仪表未找到',
    'SERIALCONFNOTEXISTS': '仪表对应的串口参数未配置',
    'DEVICETIMEOUT': '仪表返回超时',
    'DRIVERLOADFAILED': '驱动加载失败',
    'COMMANDUNSUPPORT': '传感器不支持该命令',
    'DATAFORMATERROR': '数据格式错误',
    'DATACALIBRATERROR': '数据校验失败',
    'CONTROLCODEUNSUPPORT': '传感器不支持该控制码',
    'DEVICETYPEUNSUPPORT': '传感器类型不支持',
    'CONTROLAUTHFAILED': '控制校验失败',
    'PROTOCOLUNSUPPORT': '协议不支持',
    'CHANNELPARAMLACK': '通道参数不足',
};

var ErrorCode2Message = {};
_.map(ErrorMessageList, function (v, k) {
    ErrorCode2Message[ErrorCodeList[k]] = v;
});

var HttpCodeMapping = {
    200: 0,
    401: [
        {from: 90000002, to: 90000007}
    ]
};

module.exports = exports = ErrorCodeList;

exports.Answer = function (ret, res)
{
    //
    for(var key in HttpCodeMapping){
        var codeMapping = HttpCodeMapping[key];
        if(ret.code == codeMapping){
            return res.status(key).send(ret);
        }
        else{
            _.find(codeMapping, function (mapping) {
                if(ret.code >= mapping.from && ret.code <=mapping.to){
                    return res.status(key).send(ret);
                }
                return false;
            })
        }
    }

    res.status(403).send(ret);
};

exports.ack = function (code, result) {
    let message = ErrorCode2Message[code];
    let ret = {
        code: code,
        message: message
    };
    if(result){
        ret.result = result;
    }
    return ret;
};

exports.Code = ErrorCodeList;
exports.Message = ErrorMessageList;