#!/bin/bash

pushd ~/AutoCon/network/docker

docker-compose -f ./docker-compose-autocon.yaml down
docker-compose -f ./docker-compose-ca.yaml down


docker volume prune -f

popd