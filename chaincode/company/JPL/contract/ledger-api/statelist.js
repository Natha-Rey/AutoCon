/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';
const State = require('./state.js');

/**
 * StateList provides a named virtual container for a set of ledger states.
 * Each state has a unique key which associates it with the container, rather
 * than the container containing a link to the state. This minimizes collisions
 * for parallel transactions on different states.
 */
class StateList {

    /**
     * Store Fabric context for subsequent API access, and name of list
     */
    constructor(ctx, listName) {
        this.ctx = ctx;
        this.name = listName;
        this.supportedClasses = {};

    }

    /**
     * Add a state to the list. Creates a new state in worldstate with
     * appropriate composite key.  Note that state defines its own key.
     * State object is serialized before writing.
     */
    async addState(state) {
        const key = this.ctx.stub.createCompositeKey(this.name, state.getSplitKey());
        const  data = State.serialize(state);
        await this.ctx.stub.putState(key, data);
    }

    /**
     * Get a state from the list using supplied keys. Form composite
     * keys to retrieve state from world state. State data is deserialized
     * into JSON object before being returned.
     */
    async getState(key) {
        const ledgerKey = this.ctx.stub.createCompositeKey(this.name, State.splitKey(key));
        const data = await this.ctx.stub.getState(ledgerKey);
        if (data && data.toString('utf8')) {
            const state = State.deserialize(data, this.supportedClasses);
            return state;
        } else {
            return null;
        }
    }

    /**
     * Update a state in the list. Puts the new state in world state with
     * appropriate composite key.  Note that state defines its own key.
     * A state is serialized before writing. Logic is very similar to
     * addState() but kept separate becuase it is semantically distinct.
     */
    async updateState(state) {
        const key = this.ctx.stub.createCompositeKey(this.name, state.getSplitKey());
        const data = State.serialize(state);
        await this.ctx.stub.putState(key, data);
    }

    /**
     * Fetch all the states in the list. 
     * @iterator looks for a prefix to match with 
     * and pushes matching states on to a list
     * that is displayed
     */

    async getAllJobStates(prefix){
        const states = [];
        const datas = [];
        const iterator = await this.ctx.stub.getStateByPartialCompositeKey(this.name, [prefix]);
    
        while (true) {
            const data = await iterator.next();
            datas.push(data);
    
            if (data.value && data.value.value.toString()) {
                const state = State.deserialize(data.value.value, this.supportedClasses);
                states.push(state);
            }
            if (data.done) {
                await iterator.close();
                return states;
            }
        }
    }

    /** Stores the class for future deserialization */
    use(stateClass) {
        this.supportedClasses[stateClass.getClass()] = stateClass;
    }

}

module.exports = StateList;