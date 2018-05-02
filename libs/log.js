let appRootPath = require('app-root-path');
let config = require('config');
let path = require('path');
let fs = require('fs');
let _ = require('underscore');

exports = module.exports = function(appName, logPath)
{
    logPath = logPath || 'log';
    let loggerPath = path.join(appRootPath.path, logPath);
    if(!fs.existsSync(loggerPath)){
        fs.mkdirSync(loggerPath);
    }

    const methods = ['tracer', 'warn', 'info', 'error', 'debug',  'response', 'request', 'delete', 'sys'];
    if(config.logfile) {
        global.log = require('tracer').dailyfile({
            root: logPath,
            methods: methods,
            allLogsFileName: appName,
            format: '[{{timestamp}}] {{ipAddress}}:{{pid}} {{appName}} {{title}} {{path}}{{relativePath}}:{{line}}:{{method}} {{message}}',
            dateformat: 'yyyy-mm-dd HH:MM:ss',
            maxLogFiles:365,
            preprocess: function (data) {
                let process = require('process');
                let ip = require('ip');

                data.relativePath = path.relative(appRootPath.path, data.path);
                data.path = '';
                data.title = data.title.toUpperCase();
                data.pid = process.pid;
                data.ipAddress = ip.address();
                data.appName = appName;

                _.each(data.args, function (v, i) {
                    if(_.isObject(v)){
                        data.args[i] = JSON.stringify(v);
                    }
                });
            }
        });
    }
    else{
        global.log = require('tracer').console({
            methods: methods
        });
    }
};