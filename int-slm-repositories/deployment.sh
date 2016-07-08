#!/bin/bash
### WORK INPROGRESS

#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

# MONGODB (CATALOGUE-REPOS)
# Clean database
# Removing
docker rm -fv son-mongo 
sleep 5
# Starting
docker run -d -p 27017:27017 --name son-mongo mongo
while ! nc -z sp.int3.sonata-nfv.eu 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;

# -- SLM
export DOCKER_HOST="unix:///var/run/docker.sock"

#DEPLOYMENT
#export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

# --run run SLM and catalogue/repositories containers
#docker-compose -f int-slm-repositories/scripts/docker-compose.yml down
#docker-compose -f int-slm-repositories/scripts/docker-compose.yml up -d
#sleep 10

# -- Post NSR/VNFR to NS, NF and Monitoring repositories
#int-slm-repositories/scripts/postNSR2NSRepo.sh
#int-slm-repositories/scripts/postVNFR2NFRepo.sh
#int-slm-repositories/scripts/postNSRVNFR2MonRepo.sh
#sleep 5

# -- SLM
#export DOCKER_HOST="unix:///var/run/docker.sock"
