#!/bin/bash

# Go to the network folder
pushd ~/AutoCon/network


# set cfg path
export FABRIC_CFG_PATH=$PWD/../config




peer chaincode query -C channel001 -n jobcontract -c '{"Args":["getJobByKey", "PLC:SFX002"]}'

peer chaincode query -C channel001 -n jobcontract -c '{"Args":["getJobByKey", "PLC:JPL003"]}'