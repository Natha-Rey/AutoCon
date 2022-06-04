'use strict'

// eslint-disable-next-line no-unused-vars
const State = require('../ledger-api/state.js');

//Class for query functions
class QueryUtils {
    constructor(ctx, listName){
        this.ctx = ctx;
        this.listName = listName;
    }

    //get all the jobs saved on the world state
    async getAllAssets(){
        const allResults = [];
        const startKey = '';
        const endKey = '';

        //range query returns an iterator over a set of keys. The startkey and endKey can be empty, wich implied an unbounded range.
        const iterator = await this.ctx.stub.getStateByRange(startKey, endKey);
        let result = await iterator.next();
        while(!result.done){
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return allResults;
    }
}

module.exports = QueryUtils;