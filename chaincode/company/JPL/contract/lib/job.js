'use strict';

const State = require('./../ledger-api/state.js');
//Class will define the status of a job
const JobStatus = require('./jobStatus.js');

class Job extends State {
    constructor(obj){
        /**
         * generate its own key when object is created
         * key sample: PLC:SFX001
         */
        super(Job.getClass(), ["PLC", obj.initiator + obj.jobID]);
        Object.assign(this, obj);
    }

    //Getters & Setters
    getInitiator(){
        return this.initiator;
    }

    setInitiator(newInitiator){
        this.initiator = newInitiator;
    }

    getOwner(){
        return this.owner;
    }

    setOwner(newOwner){
        this.owner = newOwner;
    }

    getOwnerMSP(){
        return this.mspid;
    }

    setOwnerMSP(mspid){
        this.mspid = mspid;
    }

    //Encapsulate job states value
    //When the job has been created and posted to the network
    setPosted(){
        this.currentState = JobStatus.Posted.name;
    }

    //When the job has been picked for another company and it's working on it
    setProcessing(){
        this.currentState = JobStatus.Processing.name;
    }

    //When the job has been completed by the company
    setDone(){
        this.currentState = JobStatus.Done.name;
    }

    isPosted(){
        return this.currentState === JobStatus.Posted.name;
    }

    isProcessing(){
        return this.currentState === JobStatus.Processing.name;
    }

    isDone(){
        return this.currentState === JobStatus.Done.name;
    }

    static fromBuffer(buffer){
        return Job.deserialize(buffer);
    }

    toBuffer(){
        return Buffer.from(JSON.stringify(this));
    }

    static deserialize(data){
        return State.deserializeClass(data, Job);
    }

    //Creates a job object
    static createJob(initiator, jobID, jobDescription, location, totalPrice, cutoutPercentage){
        return new Job({ initiator, jobID, jobDescription, location, totalPrice, cutoutPercentage});
    }

    setJobDescription(jobDescription){
        this.jobDescription = jobDescription;
    }

    setLocation(location){
        this.location = location;
    }

    setTotalPrice(totalPrice){
        this.totalPrice = totalPrice;
    }

    setCutoutPercentage(cutoutPercentage){
        this.cutoutPercentage = cutoutPercentage;
    }

    getJobDescription(){
        return this.jobDescription;
    }

    getLocation(){
        return this.location;
    }

    getTotalPrice(){
        return this.totalPrice;
    }

    getCutoutPercentage(){
        return this.cutoutPercentage;
    }
    
    static getClass(){
        return 'autocon.net'
    }
}

module.exports = Job;