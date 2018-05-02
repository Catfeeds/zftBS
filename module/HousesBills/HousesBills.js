const fp = require('lodash/fp');
const _ = require('lodash');
const bigdecimal = require('bigdecimal');
const moment = require('moment');
const schedule = require('node-schedule');

const generateProject = time => projectId => Util.getHouses(projectId, time, 'HOST')
.then(houses => Util.dailyDeviceData(houses, time)
.then(makeHousesBills(projectId, time)));

const makeHousesBills = (projectId, time) => async (housesBills = []) => {
  let bulkHousesBills = [];
  let bulkHousesBillFlows = [];

  const paymentDay = time.unix();

  _.forEach(housesBills, (billFlows, houseId) => {
    const billId = SnowFlake.next();
    const amount = _.sum(fp.map(flow => {
      return flow.amount;
    })(billFlows));
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
    bulkHousesBillFlows = _.union(bulkHousesBillFlows, flows);
    log.info(flows);

    const housesBill = {
      billId,
      projectId,
      houseId,
      paymentDay,
      createdAt: moment().unix(),
      amount: amount,
    };
    bulkHousesBills.push(housesBill);
  });
  log.info(bulkHousesBills);

  return MySQL.Sequelize.transaction(t => {
    return Promise.all([
      MySQL.HousesBills.bulkCreate(bulkHousesBills, {transaction: t}),
      MySQL.HousesBillsFlows.bulkCreate(bulkHousesBillFlows, {transaction: t}),
    ]);
  });
};

const generate = time =>
    projects =>
      Promise.all(fp.map(generateProject(time))(projects))
        .then(() => log.warn('HousesBills Done...'));

function bill(time) {
  return MySQL.Projects.findAll({attributes: ['id']}).then(generate(time));
}

exports.bill = bill;

exports.Run = () => {
  const rule = new schedule.RecurrenceRule();
  rule.hour = 1;
  rule.minute = 0;
  schedule.scheduleJob(rule, async () => {
    console.log(`Daily backend process for housebills, start from ${moment().
      format('YYYY-MM-DD hh:mm:ss')}`);
    return bill(moment().subtract(1, 'day').endOf('day'));
  });
};

exports.ModuleName = 'HousesBills';