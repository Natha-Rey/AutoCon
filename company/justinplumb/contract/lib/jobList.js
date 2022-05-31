'use strict';

const StateList = require('./../ledger-api/statelist.js');
const Job = require('./job.js');

class JobList extends StateList {
    constructor(ctx){
        super(ctx, 'autocon.net');
        this.use(Job);
    }

    async addJob(job){
        return this.addState(job);
    }

    async getJob(jobKey){
        return this.getState(jobKey);
    }

    async updateJob(job){
        return this.updateState(job);
    }
}

module.exports = JobList;