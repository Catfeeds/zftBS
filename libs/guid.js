/**
 * 解析/生成 GUID
 */

let _ = require('underscore');

let lengthOfDeviceIDField = {
    buildingid: {
        name: 'buildingid',
        length:10,
        order: 1
    },
    gatewayid: {
        name: 'gatewayid',
        length: 2,
        order: 2
    },
    addrid: {
        name: 'addrid',
        length: 12,
        order: 3
    },
    meterid: {
        name: 'meterid',
        length: 3,
        order: 4
    },
    devicetype:{
        name: 'devicetype',
        length: 3,
        order: 5
    },
    funcid: {
        name: 'funcid',
        length: 2,
        order: 6
    }
};

let LengthOfID = {
    DID: {
        length:lengthOfDeviceIDField.buildingid.length
        +lengthOfDeviceIDField.gatewayid.length
        +lengthOfDeviceIDField.addrid.length
        +lengthOfDeviceIDField.meterid.length
        +lengthOfDeviceIDField.devicetype.length
        +lengthOfDeviceIDField.funcid.length,
        fields:['buildingid', 'gatewayid', 'addrid', 'meterid', 'devicetype', 'funcid']
    },
    DIDWithoutDevicetype:{
        length:lengthOfDeviceIDField.buildingid.length
        +lengthOfDeviceIDField.gatewayid.length
        +lengthOfDeviceIDField.addrid.length
        +lengthOfDeviceIDField.meterid.length
        +lengthOfDeviceIDField.funcid.length,
        fields:['buildingid', 'gatewayid', 'addrid', 'meterid', 'funcid']
    },
    SensorID: {
        length:lengthOfDeviceIDField.buildingid.length
        +lengthOfDeviceIDField.gatewayid.length
        +lengthOfDeviceIDField.addrid.length
        +lengthOfDeviceIDField.meterid.length
        +lengthOfDeviceIDField.devicetype.length,
        fields:['buildingid', 'gatewayid', 'addrid', 'meterid', 'devicetype']
    },
    SensorIDWithoutDevicetype: {
        length:lengthOfDeviceIDField.buildingid.length
        +lengthOfDeviceIDField.gatewayid.length
        +lengthOfDeviceIDField.addrid.length
        +lengthOfDeviceIDField.meterid.length,
        fields:['buildingid', 'gatewayid', 'addrid', 'meterid']
    },
    SensorCPTID: {
        length:lengthOfDeviceIDField.buildingid.length
        +lengthOfDeviceIDField.gatewayid.length
        +lengthOfDeviceIDField.meterid.length,
        fields:['buildingid', 'gatewayid', 'meterid']
    }
};

function Padding(type, id)
{
    if(!id){
        return '';
    }
    let fieldObj = lengthOfDeviceIDField[type];
    if(!fieldObj || !id){
        return id;
    }

    let strValue = id.toString().trim();
    let fixLength = fieldObj.length - strValue.length;
    if(fixLength <= 0){
        return strValue;
    }

    for(let i=0;i<fixLength;i++){
        //
        strValue = '0' + strValue;
    }
    return strValue;
}

function DeviceID(deviceIns, buildingid, gatewayid, addrid, meterid, devicetype, funcid)
{
    //支持did/sensorid/sensorid without devicetype
    if(_.isObject(deviceIns)){
        //
        this.buildingid = deviceIns.buildingid;
        this.gatewayid = deviceIns.gatewayid;
        this.addrid = deviceIns.addrid;
        this.meterid = deviceIns.meterid;
        this.devicetype = deviceIns.devicetype;
        this.funcid = deviceIns.funcid;

        this.isValid = true;
    }
    else if(_.isString(deviceIns)){
        //
        let deviceIDFields = this.Parse(deviceIns);
        if(deviceIDFields){
            this.buildingid = deviceIDFields.buildingid;
            this.gatewayid = deviceIDFields.gatewayid;
            this.addrid = deviceIDFields.addrid;
            this.meterid = deviceIDFields.meterid;
            this.devicetype = deviceIDFields.devicetype;
            this.funcid = deviceIDFields.funcid;
            this.isValid = true;
        }
    }
    else{
        this.buildingid = buildingid;
        this.gatewayid = gatewayid;
        this.addrid = addrid;
        this.meterid = meterid;
        this.devicetype = Padding('devicetype', devicetype);
        this.funcid = funcid;
        this.Format();

        this.isValid = true;
    }

    this.Format();
}

DeviceID.prototype.Format = function()
{
    this.buildingid = Padding('buildingid', this.buildingid);
    this.gatewayid = Padding('gatewayid', this.gatewayid);
    this.addrid = Padding('addrid', this.addrid);
    this.meterid = Padding('meterid', this.meterid);
    this.devicetype = Padding('devicetype', this.devicetype);
    this.funcid = Padding('funcid', this.funcid);
};

//是否为有效DeviceID Object
DeviceID.prototype.IsValid = function()
{
    return this.isValid;
};

/*
 * 解析设备ID
 * */
DeviceID.prototype.Parse = function(deviceID)
{
    if(!deviceID){
        return;
    }

    deviceID = deviceID.trim();
    //长度判定
    let idType = _.find(LengthOfID, function (item) {
        return deviceID.length == item.length;
    });

    if(!idType){
        return;
    }

    //build deviceIDFields
    let deviceIDFields = {};
    _.each(idType.fields, function (field) {
        deviceIDFields[field] = lengthOfDeviceIDField[field];
    });

    deviceIDFields = _.sortBy(deviceIDFields, 'order');
    let obj = {};
    _.each(deviceIDFields, function(item){
        obj[item.name] = deviceID.substr(0, item.length).trim();
        deviceID = deviceID.substr(item.length);
    });

    return obj;
};
/*
 * 返回采集器ID
 * */
DeviceID.prototype.CollectorID = function()
{
    return this.buildingid + this.gatewayid;
};
/*
 * 返回传感器ID
 * */
DeviceID.prototype.SensorID = function()
{
    return this.buildingid + this.gatewayid + this.addrid + this.meterid + this.devicetype;
};
/*
 * 返回传感器通道ID
 * */
DeviceID.prototype.ChannelID = function()
{
    return this.buildingid + this.gatewayid + this.addrid + this.meterid + this.devicetype + this.funcid;
};

//非平台信息设备ID
DeviceID.prototype.EquipmentID = function () {
    return this.buildingid + this.gatewayid + this.addrid + this.meterid + this.funcid;
};

/*
 * 生成传感器指令透传ID(Sensor Command Pass Through ID ==> buildingID+gatewayID+meterID)
 * */
DeviceID.prototype.SensorCPTID = function()
{
    return this.buildingid + this.gatewayid + this.meterid;
};
//返回id集合
DeviceID.prototype.IDSet = function ()
{
    return {
        buildingid: this.buildingid,
        gatewayid: this.gatewayid,
        addrid: this.addrid,
        meterid: this.meterid,
        funcid: this.funcid
    };
};


module.exports = exports = function(){
};

exports.Padding = function(type, id)
{
    return Padding(type, id);
};

exports.LengthOfSensorID = lengthOfDeviceIDField;
/*解析传感器id
 {
 buildingid: xxx,    //建筑id
 gatewayid: xxx,     //网关id
 addr: xxx,          //地址
 meterid: xxx
 funcid: xxx         //通道id
 }
 * */
exports.ParseSensorID = function(id)
{
    //
    if(!id || !id.length){
        return null;
    }

    let obj = {};
    _.map(lengthOfDeviceIDField, function(length, name){
        obj[name] = id.substr(0, length);
        id = id.substr(length);
    });

    return obj;
};

function FixLength(value, fixToLength, padding)
{
    //
    let strValue = value.toString();
    let fixLength = fixToLength - strValue.length;
    if(fixLength <= 0){
        return strValue;
    }

    for(let i=0;i<fixLength;i++){
        //
        strValue = padding + strValue;
    }
    return strValue;
}
exports.GenerateSensorID = function(obj)
{
    return obj.buildingid
        + obj.gatewayid
        + obj.addrID
        + FixLength(obj.meterid, lengthOfDeviceIDField.meterid, '0')
        + obj.devicetype
        + FixLength(obj.funcid, lengthOfDeviceIDField.funcid, '0');
};

/*
 * 比较2个通道是否属于同一个传感器
 * */
exports.IsSameSensor = function(sensorA, sensorB)
{
    if(!sensorA || !sensorB || !sensorA.length || !sensorB.length){
        console.error('One Of Sensor is empty', sensorA, sensorB);
        return false;
    }
    let sensorAID = sensorA.substr(0, sensorA.length-lengthOfDeviceIDField.funcID);
    let sensorBID = sensorB.substr(0, sensorB.length-lengthOfDeviceIDField.funcID);
    return sensorAID == sensorBID;
};

/*
 * 生成MiniSID 最小唯一传感器ID(buildingID+gatewayID+meterID)用于传感器命令透传
 * */
exports.MiniSID = function(sid)
{
    //
    let Build = function(obj)
    {

        return obj.buildingid + obj.gatewayid+ obj.meterid;
    };

    if(typeof(sid) == 'string'){
        //SID
        let sidObj = exports.ParseSensorID(sid);
        return Build(sidObj);
    }
    else if(typeof(sid) == 'object'){
        return Build(sid);
    }

    return '';
};

exports.FromCPTID = function (deviceID)
{
    if(!deviceID){
        return;
    }

    deviceID = deviceID.trim();
    let cptDeviceIDField = {
        buildingid: lengthOfDeviceIDField.buildingid,
        gatewayid: lengthOfDeviceIDField.gatewayid,
        meterid: lengthOfDeviceIDField.meterid
    };
    let obj = {};
    _.map(cptDeviceIDField, function(length, name){
        obj[name] = deviceID.substr(0, length).trim();
        deviceID = deviceID.substr(length);
    });

    return exports.DeviceID(obj);
};
exports.DeviceID = function(deviceIDStr, buildingid, gatewayid, addrid, meterid, devicetype, funcid)
{
    return new DeviceID(deviceIDStr, buildingid, gatewayid, addrid, meterid, devicetype, funcid);
};
exports.DIDLengthCheck = function(deviceid)
{
    let maxLength = 0;
    _.each(lengthOfDeviceIDField, function (fields) {
        maxLength += fields;
    });
    return (deviceid.length == maxLength);
};
