#!/bin/bash

pushd ~/AutoCon/network/docker

# core.yaml contains the configuration including which database to use
# if you want to use couchDB for the state database, you can override core.yaml file or
# better option is to include the parameters in another file, docker-compose-couch.yaml
# and then run the network including this file, this way the core.yaml parameters are overrident


docker-compose -f ./docker-compose-autocon.yaml -f ./docker-compose-couch.yaml up -d 

popd