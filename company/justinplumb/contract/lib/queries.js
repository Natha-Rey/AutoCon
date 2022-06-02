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
        for await (const res of iterator) {
            allResults.push(res.value.toString('utf8'));
        }

        return allResults;
    }
}

module.exports = QueryUtils;