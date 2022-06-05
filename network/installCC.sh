#!/bin/bash

# go to the chaincode location for org2
pushd ~/AutoCon/chaincode/company/JPL/contract

# add the dependencies
npm install

# go to the chaincode location for org1
pushd ~/AutoCon/chaincode/company/SFX/contract

# add the dependencies
npm install

popd


# return to the network folder
pushd ~/AutoCon/network

# set cfg path
export FABRIC_CFG_PATH=$PWD/../config

# package the chaincode
peer lifecycle chaincode package jobcontract.tar.gz --path ../chaincode/company/JPL/contract/ --lang node --label jobcontract_1.0

# Set environment to Org1 - SFX
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/Admin@SFX.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:7051

# Install the chaincode
peer lifecycle chaincode install jobcontract.tar.gz

# Set environment to Org2 - JPL
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/JPL.autocon.net/users/Admin@JPL.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:9051

# Install the chaincode
peer lifecycle chaincode install jobcontract.tar.gz

# Get the package ID of the chaincode
peer lifecycle chaincode queryinstalled