'use strict';
/**
 * JobStatus represents the status a job will have while transitioning from 
 * one status to another. Once the job is created and added to the network, its status will be set
 * to Posted. When a company is working on the job, its status will change to Processing. Finally,
 * once the job is completed, its status will change to Done.
 */
class JobStatus {
    static Posted = new JobStatus("Posted");
    static Processing = new JobStatus("Processing");
    static Done = new JobStatus("Done");

    constructor(name){
        this.name = name;
    }
}

module.exports = JobStatus;