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

# -- BSS
#if ! [[ "$(docker inspect -f {{.State.Running}} son-bss 2> /dev/null)" == "" ]]; then docker rm -fv son-bss ; fi
#docker run -d --name son-bss -p 25001:1337 -p 25002:1338 -it registry.sonata-nfv.eu:5000/son-yo-gen-bss

export DOCKER_HOST="unix:///var/run/docker.sock"

