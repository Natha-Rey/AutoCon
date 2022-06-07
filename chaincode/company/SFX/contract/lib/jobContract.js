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
     * Posts a job
    */
    async postJob(ctx, initiator, jobID, jobDescription, location,  totalPrice, cutoutPercentage){
        // create an instance of the job
        const job = Job.createJob(initiator, jobID, jobDescription, location, parseFloat(totalPrice), parseFloat(cutoutPercentage));

        //Set posted state by the smart contract
        job.setPosted();

        //save the owner's MSP
        const mspid = ctx.clientIdentity.getMSPID();
        job.setOwnerMSP(mspid);

        //The job will be owned by the company who posted it
        job.setOwner(initiator);

        //Add the job to the job list in the ledger world state
        await ctx.jobList.addJob(job);

        //Return a serialized job to the caller
        return job;

    }

    /**
     * Returns a job depending on its composite key.
     * composite key eg. PLC:SFX001
     */ 
    async getJobByKey(ctx, key){     
        const result = ctx.jobList.getJob(key);
        return result;
    }
    
    /**
     * updates the specifics of the job
     */

    async updateJob(ctx, initiator, jobID, jobDescription, location,  totalPrice, cutoutPercentage){
        const jobKey = Job.makeKey(["PLC", initiator + jobID]);
        const job = await ctx.jobList.getJob(jobKey);
        
        
        // validate if the state of the job is Processing or Done already
        if(job.isProcessing() || job.isDone()){
            throw new Error('Job ' + initiator + jobID + ' cannot be modified in this state.')
        }

        //Validate user invoking the fuction is the one that posted the job
        if(job.getOwnerMSP() !== ctx.clientIdentity.getMSPID()) {
            throw new Error('Job ' + initiator + jobID + ' cannot be modified by ' + ctx.clientIdentity.getMSPID() + ' as it is not the owner Organization');
        }

        job.setJobDescription(jobDescription);
        job.setLocation(location);
        job.setTotalPrice(totalPrice);
        job.setCutoutPercentage(cutoutPercentage);

        await ctx.jobList.updateJob(job);
        return job;
    }
    /**
     * Applies for a job and changes status to 'Processing'
     */


    async ApplyForJob(ctx,initiator,jobID){
        const jobKey = Job.makeKey(["PLC", initiator + jobID]);
        const job = await ctx.jobList.getJob(jobKey);
        
        
        // validate if the state of the job is Processing or Done already
        if(job.isProcessing() || job.isDone()){
            throw new Error('Job ' + initiator + jobID + ' cannot be modified in this state.')
        }

        //Validate user invoking the fuction is the one that posted the job
        if(job.getOwnerMSP() !== ctx.clientIdentity.getMSPID()) {
            throw new Error('Job ' + initiator + jobID + ' cannot be modified by ' + ctx.clientIdentity.getMSPID() + ' as it is not the owner Organization');
        }

        job.setProcessing();

        await ctx.jobList.ApplyforJob(job)
        return job;
        


    }
    /**
     * Fetches all the K:V pairs stored in the ledger
     */

    async fetchAllJobs(ctx, partialKey){
        const result = await ctx.jobList.getAllJobs(partialKey);
        return result;
    }
}

module.exports = JobContract;