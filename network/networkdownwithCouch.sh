#!/bin/bash

pushd ~/AutoCon/network/docker

docker-compose -f ./docker-compose-autocon.yaml down
docker-compose -f ./docker-compose-ca.yaml down
docker container stop couchdb1 couchdb0

docker container prune -f

docker volume prune -f

docker network prune -f

popd
