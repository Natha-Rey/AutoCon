#!/bin/bash

# create channel artifacts folder
mkdir ~/AutoCon/network/channel-artifacts

pushd ~/AutoCon/network

# set the cfg path
export FABRIC_CFG_PATH=$PWD/configtx/

# create the channel creation transaction
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel001.tx -channelID channel001

# set environment to the admin user of Org1 - SFX
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="SFXMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/Admin@SFX.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:7051

# set the cfg path to the core file
export FABRIC_CFG_PATH=$PWD/../config

# create the channel
peer channel create -o localhost:7051  --ordererTLSHostnameOverride orderer.autocon.net -c channel001 -f ./channel-artifacts/channel001.tx --outputBlock ./channel-artifacts/channel001.block --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

# join org1 to the channel
peer channel join -b ./channel-artifacts/channel001.block

# show the blockheight of the channel
peer channel getinfo -c channel001

# set environment to the admin user of Org2 - JPL
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="JPLMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/JPL.autocon.net/peers/peer0.JPL.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/JPL.example.com/users/Admin@JPL.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:9051

# fetch the first block from the ordering service
peer channel fetch 0 ./channel-artifacts/channel002.block -o localhost:7050 --ordererTLSHostnameOverride orderer.autocon.net -c channel001 --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

# join org2 to the channel
peer channel join -b ./channel-artifacts/channel002.block

# set the cfg path
export FABRIC_CFG_PATH=$PWD/configtx/

# create the anchor update transaction for org2
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/JPL_anchor.tx -channelID channel001 -asOrg JPLMSP

# set the cfg path to the core file
export FABRIC_CFG_PATH=$PWD/../config

# send the anchor update to the ordering service
peer channel update -o localhost:7050 -c channel001 -f ./channel-artifacts/JPL_anchor.tx --ordererTLSHostnameOverride orderer.autocon.net --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

# set environment to the admin user of Org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="SFXMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/SFX.autocon.net/peers/peer0.SFX.autocon.net/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/SFX.autocon.net/users/Admin@SFX.autocon.net/msp
export CORE_PEER_ADDRESS=localhost:7051

# set the cfg path
export FABRIC_CFG_PATH=$PWD/configtx/

# create the anchor update transaction for org1
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/SFX_anchor.tx -channelID channel001 -asOrg SFXMSP

# set the cfg path to the core file
export FABRIC_CFG_PATH=$PWD/../config

# send the anchor update to the ordering service
peer channel update -o localhost:7050 -c channel001 -f ./channel-artifacts/SFX_anchor.tx  --ordererTLSHostnameOverride orderer.autocon.net --tls --cafile ${PWD}/organizations/ordererOrganizations/autocon.net/orderers/orderer.autocon.net/msp/tlscacerts/tlsca.autocon.net-cert.pem

# show the blockheight of the channel
peer channel getinfo -c channel001

popd
