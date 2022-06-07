#!/bin/bash


# Go to the network folder
pushd ~/AutoCon/network


# set cfg path
export FABRIC_CFG_PATH=$PWD/../config


# run 'fetchAllJobs' command 

peer chaincode query -C channel001 -n jobcontract -c '{"Args":["fetchAllJobs","PLC"]}'