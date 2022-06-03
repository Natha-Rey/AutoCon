#!/bin/bash

# remove the old materials
sudo rm -fr ~/AutoCon/network/organizations/ordererOrganizations/*
sudo rm -fr ~/AutoCon/network/organizations/peerOrganizations/*
sudo rm -fr ~/AutoCon/network/system-genesis-block/*



#deploy the ca's

pushd ~/AutoCon/network/docker
docker-compose -f docker-compose-ca.yaml up -d
popd

sleep 10

#generate crypto materials

pushd ~/AutoCon/network
./organizations/fabric-ca/registerEnroll.sh

# set the cfg path
export FABRIC_CFG_PATH=$PWD/configtx/

# create the genesis block
configtxgen -profile TwoOrgsOrdererGenesis -channelID autocon-network -outputBlock ./system-genesis-block/genesis.block 

popd
