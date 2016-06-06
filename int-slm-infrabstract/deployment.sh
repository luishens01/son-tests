#!/bin/bash
#DEPLOYMENT
#WORK IN PROGRESS ...
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"

# -- run slm and infrabstract containers
docker-compose -f int-slm-infrabstract/scripts/docker-compose.yml down
docker-compose -f int-slm-infrabstract/scripts/docker-compose.yml up -d
sleep 10
docker-compose  -f int-slm-infrabstract/scripts/docker-compose.yml run 
sleep 10

# -- Send service deploy message to IA 
int-slm-infrabstract/scripts/msg2infrabstract.sh
sleep 180

export DOCKER_HOST="unix:///var/run/docker.sock"

