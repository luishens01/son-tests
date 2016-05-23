#!/bin/bash

export DOCKER_HOST="tcp://192.168.60.25:2375"

# swtich to folder with docker-compose.yml to be used
cd int-service-platform
docker-compose down
set -e
set -x
# START ENTIRE SERVICE PLATFORM ENVIRONMENT
docker-compose up -d
sleep 10
docker-compose run --rm son-gtksrv bundle exec rake db:migrate

# TRIGGER TESTS (done by exmple plugin for now. Will be changed when GK to Rabbit impl. is available)
#docker-compose run exampleplugin son-mano-example-plugin-1

export DOCKER_HOST="unix:///var/run/docker.sock"
