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


## Approve the chaincode ##
# Get the package ID of our chaincode
peer lifecycle chaincode queryinstalled >&log.txt

# export the ID as a variable
export CC_PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

# Approve for Org2 - JPL
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.autocon.net --channelID channel001 --name jobcontract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem"

# Check the approvals
peer lifecycle chaincode checkcommitreadiness --channelID channel001 --name jobcontract --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem --output json

# Set environment to Org1 - SFX
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/Admin@SFX.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:7051

# Approve for Org1 - SFX
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.autocon.net --channelID channel001 --name jobcontract --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem"

# Check the approvals
peer lifecycle chaincode checkcommitreadiness --channelID channel001 --name jobcontract --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem --output json

# Commit the approved chaincode for both of the organizations
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.autocon.net --channelID channel001 --name jobcontract --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt

# Confirm chaincode definition committed
peer lifecycle chaincode querycommitted --channelID channel001 --name jobcontract --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

# Initialize the chaincode
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.autocon.net --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem -C channel001 -n jobcontract --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt -c '{"Args":["init"]}'
