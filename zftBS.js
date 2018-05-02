require('include-node');
const config = require('config');
const _ = require('lodash');
Include( '/libs/log')("zftBS");
const {job: cronJob} = require('./libs/cronJob');

{
    global.MySQL = Include('/libs/mysql');
    global.GUID = Include('/libs/guid');
    global.Message = Include('/libs/message');
    global.ErrorCode = Include('/libs/errorCode');
    global.SnowFlake = Include('/libs/snowflake').Alloc(1, 2);
    global.Util = Include('/libs/util');
}

require('process').on('unhandledRejection', (reason, p) => {
    console.log('Unhandled Rejection at: Promise', p, 'reason:', reason);
});

MySQL.Load().then(
    ()=>{
        cronJob();
        {
            //Run All the Modules
            let baseDir = '/';
            let modulePath = 'module';
            let files;
            let fs = require('fs');
            let path = require('path');
            try{
                files = fs.readdirSync(modulePath);
            }
            catch(e){
                log.error('Error: ', e);
            }

            if(files){
                _.each(files, function(basename){
                    //
                    let newSubPath = path.join(modulePath, basename);
                    let moduleName = path.join(newSubPath, path.basename(newSubPath));
                    moduleName = path.join(baseDir, moduleName);
                    try {
                        let handle = Include(moduleName);
                        global[handle.ModuleName] = handle;
                        global[handle.ModuleName].Run();
                        log.debug(moduleName, '==>', global[handle.ModuleName].ModuleName);
                    }
                    catch(e){
                        log.error(moduleName, 'load error', e);
                    }
                })
            }
        }
    }
);