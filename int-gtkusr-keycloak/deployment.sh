#!/bin/bash
###WORK IN PROGRESS
#DEPLOYMENT
# export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
export DOCKER_HOST="unix:///var/run/docker.sock"

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
echo Stopping and removing containers
docker stop son-gtkusr &&
docker rm -fv son-gtkusr &&
docker stop sonata-keycloak &&
docker rm -fv sonata-keycloak &&
sleep 5
# Starting
# docker run -d -p 5600:5600 --name son-gtkusr -e KEYCLOAK_ADDRESS=keycloak e- KEYCLOAK_PORT=5601 e- KEYCLOAK_PATH=auth e- SONATA_REALM=sonata e- CLIENT_NAME=adapter registry.sonata-nfv.eu:5000/son-gtksrv
# Running docker compose using development deployment pushed images
#     the images referenced in docker-compose-run.yml
#     are tagged at the build stage https://jenkins.sonata-nfv.eu/view/DEVELOPMENT/job/son-gkeeper/configure
#
echo Building new containers
docker-compose -f int-gtkusr-keycloak/resources/docker-compose_run.yml up -d

echo Waiting for son-gtkusr ...
# while ! nc -z sp.int3.sonata-nfv.eu 5600; do
while ! nc -z localhost 5600; do
  sleep 1 && echo -n .; # waiting for gtkusr
done;
echo son-gtkusr Ready!

echo Waiting for son-gtkusr-keycloak ...
# while ! nc -z sp.int3.sonata-nfv.eu 5601; do
while ! nc -z localhost 5601; do
  sleep 1 && echo -n .; # waiting for gtkusr
done;
echo son-gtkusr-keycloak Ready!

sleep 5

echo Starting Tests


export DOCKER_HOST="unix:///var/run/docker.sock"
