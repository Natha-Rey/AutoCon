'use strict'

//Fabric Smart Contract classes
const { Contract, Context } = require('fabric-contract-api');
// AutoCon network classes
const Job = require('./job.js');
const JobList = require('./jobList.js');

//Custom context to easily access list of all jobs
class JobContext extends Context {
    constructor(){
        super();
        //All jobs are kept in a list of jobs
        this.jobList = new JobList(this);
    }
}

class JobContract extends Contract {
    constructor() {
        super('autocon.net');
    }

    createContext(){
        return new JobContext();
    }

    //This could perform any setup of the ledger if required.
    //Not required for this prototype
    async init(ctx){
        console.log("Contract Init");
    }

    /** 
     * Post a job
    */
    async post(ctx, initiator, jobID, jobDescription, location, contactPhoneNumber, totalPrice, cutoutPercentage){
        
    }
}

module.exports = JobContract;