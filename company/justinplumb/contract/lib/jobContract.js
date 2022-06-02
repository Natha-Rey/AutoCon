'use strict'

//Fabric Smart Contract classes
const { Contract, Context } = require('fabric-contract-api');
// AutoCon network classes
const Job = require('./job.js');
const JobList = require('./jobList.js');
const QueryUtils = require('./queries.js');

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

    /**
     * This could perform any setup of the ledger if required.
     * @param {Context} ctx transaction context
     */
    //Not required for this prototype
    // eslint-disable-next-line no-unused-vars
    async init(ctx){
        console.log("Contract Init");
    }

    /** 
     * Post a job
    */
    async postJob(ctx, initiator, jobID, jobDescription, location,  totalPrice, cutoutPercentage){
        // create an instance of the job
        let job = Job.createJob(initiator, jobID, jobDescription, location, parseFloat(totalPrice), parseFloat(cutoutPercentage));

        //Set posted state by the smart contract
        job.setPosted();

        //save the owner's MSP
        let mspid = ctx.clientIdentity.getMSPID();
        job.setOwnerMSP(mspid);

        //The job will be owned by the company who posted it
        job.setOwner(initiator);

        //Add the job to the job list in the ledger world state
        await ctx.jobList.addJob(job);

        //Return a serialized job to the caller
        return job;

    }

    async fetchAllJobs(ctx){
        let query = new QueryUtils(ctx, 'autocon.net');
        let allJobs = await query.getAllAssets();
        return JSON.stringify(allJobs);
    }
}

module.exports = JobContract;