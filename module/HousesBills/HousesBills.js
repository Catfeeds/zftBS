const fp = require('lodash/fp');
const moment = require('moment');
const schedule = require('node-schedule');

const generateProject = (time, projectId) => Util.getHouses(projectId, time,
    'HOST').
    then(
        houses => {
            Util.dailyDeviceData(houses, time).then(makeHousesBills(projectId, time))
        },
    err=>{
            log.error(err);
    }
);

const makeHousesBills = (projectId, time) => async (housesBills = []) => {
    const paymentDay = time.unix();

    const allData = fp.map(([houseId, billFlows]) => {
        const billId = SnowFlake.next();
        const amount = fp.sum(fp.map('amount')(billFlows));
        const flows = fp.map(flow => {
            return {
                billId,
                deviceId: flow.deviceId,
                amount: flow.amount,
                scale: flow.scale,
                usage: flow.usage,
                price: flow.price,
                paymentDay,
                createdAt: moment().unix(),
            };
        })(billFlows);

        const housesBill = {
            billId,
            projectId,
            houseId,
            paymentDay,
            createdAt: moment().unix(),
            amount: amount,
        };
        return {bulkHousesBillFlows: flows, bulkHousesBills: [housesBill]};
    })(fp.toPairs(housesBills));

    const bulkHousesBills = fp.flatten(
        fp.map(fp.get('bulkHousesBills'))(allData));
    const bulkHousesBillFlows = fp.flatten(
        fp.map(fp.get('bulkHousesBillFlows'))(allData));
    log.info(bulkHousesBills);
    log.info(bulkHousesBillFlows);

    return MySQL.Sequelize.transaction(t => {
        return Promise.all([
            MySQL.HousesBills.bulkCreate(bulkHousesBills, {transaction: t}),
            MySQL.HousesBillsFlows.bulkCreate(bulkHousesBillFlows,
                {transaction: t}),
        ]);
    });
};

const generate = time =>
    projects =>
        Promise.all(fp.map(project=>{
            generateProject(time, project.id)
        })(projects)).
            then(() => log.warn('HousesBills Done...'));

function bill(time) {
    return MySQL.Projects.findAll({attributes: ['id']}).then(generate(time));
}

exports.bill = bill;

exports.Run = () => {
    const rule = new schedule.RecurrenceRule();
    rule.hour = 1;
    rule.minute = 0;
    // schedule.scheduleJob(rule, async () => {
    //     console.log(
    //         `Daily backend process for housebills, start from ${moment().
    //             format('YYYY-MM-DD hh:mm:ss')}`);
    //     return bill(moment().subtract(1, 'day').endOf('day'));
    // });
    bill(moment('20171104', 'YYYYMMDD').subtract(1, 'day').endOf('day'));
};

exports.ModuleName = 'HousesBills';