#!/bin/bash
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

# --run run SLM and catalogue/repositories containers
docker-compose -f int-slm-repositories/scripts/docker-compose.yml down
docker-compose -f int-slm-repositories/scripts/docker-compose.yml up -d
sleep 10

# -- Post NSR/VNFR to NS, NF and Monitoring repositories
int-slm-repositories/scripts/postNSR2NSRepo.sh
int-slm-repositories/scripts/postVNFR2NFRepo.sh
int-slm-repositories/scripts/postNSRVNFR2MonRepo.sh
sleep 5

# -- SLM

export DOCKER_HOST="unix:///var/run/docker.sock"
