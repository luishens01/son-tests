#!/bin/bash
#DEPLOYMENT
#WORK IN PROGRESS ...
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
set -e
set -x

# -- build the trigger-container
docker build -t slm_ia_trigger ./int-slm-infrabstractV1/test-trigger
docker build -t slm_ia_cleaner ./int-slm-infrabstractV1/test-cleaner

echo "" > ./int-slm-infrabstractV1/triggerLog.txt
echo "" > ./int-slm-infrabstractV1/instanceId.conf

# -- run slm and infrabstract containers
# -- the Int Infrastructure is already running
# docker-compose -f int-slm-infrabstract/scripts/docker-compose.yml down
# docker-compose -f int-slm-infrabstract/scripts/docker-compose.yml up -d
# sleep 10
# docker-compose  -f int-slm-infrabstract/scripts/docker-compose.yml run 
# sleep 10

# -- Send service deploy message to IA
# -- This section goes in the test.sh 
# int-slm-infrabstract/scripts/msg2infrabstract.sh
# sleep 180

#export DOCKER_HOST="unix:///var/run/docker.sock"


