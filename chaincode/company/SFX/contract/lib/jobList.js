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

    async getJob(key){
        return this.getState(key);
    }

    async updateJob(job){
        return this.updateState(job);
    }

    async getAllJobs(prefix){
        return this.getAllJobStates(prefix);
    }
    async ApplyforJob(job){
        return this.updateState(job);
    }
}

module.exports = JobList;