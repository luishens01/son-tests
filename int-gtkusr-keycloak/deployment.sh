#!/bin/bash
###WORK IN PROGRESS
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

# MONGODB (USER_MANAGEMENT) Not implemented yet
# Clean database
# Removing
#docker rm -fv son-mongo
#sleep 5
# Starting
#docker run -d -p 27016:27016 --name son-mongo mongo
#while ! nc -z sp.int3.sonata-nfv.eu 27016; do
#  sleep 1 && echo -n .; # waiting for mongo
#done;

# ADAPTER - GTKUSR (GATEKEEPER)
# Removing
docker rm -fv son-gtkusr
sleep 5
# Starting
docker run -d -p 5600:5600 --name son-gtkusr -e KEYCLOAK_ADDRESS=keycloak e- KEYCLOAK_PORT=5601 e- KEYCLOAK_PATH=auth e- SONATA_REALM=sonata e- CLIENT_NAME=adapter registry.sonata-nfv.eu:5000/son-gtksrv
while ! nc -z sp.int3.sonata-nfv.eu 5600; do
  sleep 1 && echo -n .; # waiting for gtkusr
done;
sleep 5

# KEYCLOAK
cd int-gtkusr-keycloak/resources
./Dockerfile-Keycloak


export DOCKER_HOST="unix:///var/run/docker.sock"