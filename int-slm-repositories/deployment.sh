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

# MySQL (Monitoring)
# Clean database
# Removing
docker rm -fv son-monitor-mysql
sleep 5
# Starting
docker run -d -p 3306:3306 --name son-monitor-mysql registry.sonata-nfv.eu:5000/son-monitor-mysql
while ! nc -z sp.int3.sonata-nfv.eu 27017; do
  sleep 1 && echo -n .; # waiting for mysql
done;

# Check if RabbitMQ is running
if ! nc -z sp.int3.sonata-nfv.eu 5672; then
  echo "Initializing RabbitMQ docker"
  docker run -d -p 5672:5672 --name son-broker rabbitmq:3
  while ! nc -z sp.int3.sonata-nfv.eu 5672; do
    sleep 1 && echo -n .; # waiting for rabbitmq
  done;
fi

# Check if NSR/VNFR repositories are running
if ! nc -z sp.int3.sonata-nfv.eu 4002; then
  echo "Initializing Repositories"
  docker run -d -p 4002:4002  --name son-catalogue-repos registry.sonata-nfv.eu:5000/son-catalogue-repos
  while ! nc -z sp.int3.sonata-nfv.eu 4002; do
    sleep 1 && echo -n .; # waiting for repositories
  done;
fi

# Check if SLM is running
is_running=`docker inspect -f {{.State.Running}} servicelifecyclemanagement`;
if [ "$is_running" = "false" ]; then
  echo "Initializing SLM"
  docker run -d --name servicelifecyclemanagement registry.sonata-nfv.eu:5000/servicelifecyclemanagement
  while [ "$is_running" = "false" ]; do
    sleep 1 && echo -n .; # waiting for SLM
    is_running=`docker inspect -f {{.State.Running}} servicelifecyclemanagement`;
  done
fi

## TODO Add Monitoring dockers

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
