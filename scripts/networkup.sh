#!/bin/bash

pushd ~/AutoCon/network/docker

docker-compose -f ./docker-compose-autocon.yaml up -d 

popd