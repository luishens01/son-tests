#!/bin/bash
###WORK IN PROGRESS
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
# export DOCKER_HOST="unix:///var/run/docker.sock"

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

function wait_for_web() {
    until [ $(curl --connect-timeout 15 --max-time 15 -k -s -o /dev/null -I -w "%{http_code}" $1) -eq $2 ]; do
	sleep 2 && 	echo -n .;

	let retries="$retries+1"
	if [ $retries -eq 12 ]; then
	    echo "Timeout waiting for $2 status on $1"
	    exit 1
	fi
    done
}

# ADAPTER - GTKUSR (GATEKEEPER)
# Removing
echo Stopping and removing containers
docker stop son-gtkusr &&
docker rm -fv son-gtkusr &&
docker stop sonata-keycloak &&
docker rm -fv sonata-keycloak &&
sleep 5

echo Building new containers
docker-compose -f int-gtkusr-keycloak/resources/docker-compose_run.yml up -d

echo Waiting for son-gtkusr ...
# while ! nc -z sp.int3.sonata-nfv.eu 5600; do
while ! nc -z sp.int3.sonata-nfv.eu 5600; do
  sleep 1 && echo -n .; # waiting for gtkusr
done;
echo son-gtkusr Ready!

echo Waiting for son-gtkusr-keycloak ...
# while ! nc -z sp.int3.sonata-nfv.eu 5601; do
wait_for_web sp.int3.sonata-nfv.eu:5601 200
while ! nc -z localhost 5601; do
  sleep 1 && echo -n .; # waiting for gtkusr
done;
echo son-gtkusr-keycloak Ready!

sleep 5

echo Starting Tests


export DOCKER_HOST="unix:///var/run/docker.sock"
