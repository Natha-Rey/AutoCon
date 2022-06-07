#!/bin/bash

# Go to the network folder
pushd ~/AutoCon/network


# set cfg path
export FABRIC_CFG_PATH=$PWD/../config


# Set environment to Org2 - JPL
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/JPL.autocon.net/users/Admin@JPL.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:9051






# run 'updateJob' command



peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.autocon.net --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem -C channel001 -n jobcontract --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt   -c '{"Args":["updateJob", "JPL", "003", "Clean pipes and Faucet + fix geyser", "Road 3, Richmond Hill", "98.22", "23"]}'