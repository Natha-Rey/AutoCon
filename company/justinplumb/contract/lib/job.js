'use strict';

const State = require('./../ledger-api/state.js');
//Class will define the status of a job
const JobStatus = require('./jobStatus.js');

class Job extends State {
    constructor(obj){
        /**
         * generate its own key when object is created
         * key sample: justinplumb001
         */
        super(Job.getClass(), [obj.initiator, obj.jobID]);
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

    //Encapsulate job states value
    //When the job has been created and posted to the network
    setPosted(){
        this.currentState = JobStatus.Posted;
    }

    //When the job has been picked for another company and it's working on it
    setProcessing(){
        this.currentState = JobStatus.Processing;
    }

    //When the job has been completed by the company
    setDone(){
        this.currentState = JobStatus.Done;
    }

    isPosted(){
        return this.currentState === JobStatus.Posted.statusName;
    }

    isProcessing(){
        return this.currentState === JobStatus.Processing.statusName;
    }

    isDone(){
        return this.currentState === JobStatus.Done.statusName;
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
    static createInstance(initiator, jobID, jobDescription, location, contactPhoneNumber, totalPrice, cutoutPercentage){
        return new Job({ initiator, jobID, jobDescription, location, contactPhoneNumber, totalPrice, cutoutPercentage});
    }

    static getClass(){
        return 'autocon.net'
    }
}

module.exports = Job;