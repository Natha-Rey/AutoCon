#!/bin/bash

# remove the old materials
sudo rm -fr ~/AutoCon/network/organizations/ordererOrganizations/*
sudo rm -fr ~/AutoCon/network/organizations/peerOrganizations/*
sudo rm -fr ~/AutoCon/network/system-genesis-block/*

pushd ~/AutoCon/network

# generate crypto materials
cryptogen generate --config=./organizations/cryptogen/crypto-config-SFX.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-JPL.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# set the cfg path
export FABRIC_CFG_PATH=$PWD/configtx/

# create the genesis block
configtxgen -profile TwoOrgsOrdererGenesis -channelID Autocon-network -outputBlock ./system-genesis-block/genesis.block 

popd