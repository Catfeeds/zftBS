'use strict';

const schedule = require('node-schedule');
const moment = require('moment');

const rule = new schedule.RecurrenceRule();
rule.hour = 8;
rule.minute = 0;

exports.job = () => schedule.scheduleJob(rule, async () => {
    console.log(`Daily backend process, start from ${moment().
        format('YYYY-MM-DD hh:mm:ss')}`);
    return Promise.all([
        sample(),
    ]);
});

const sample = async () => {
    console.log(`sample process running at ${moment()}`);
};

