#!/bin/bash
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

contId=$(docker ps  | grep registry.sonata-nfv.eu:5000/son-gui | awk '{ print $1 }')

if [ -z "$contId" ];
 then
   echo "Error: GUI container running not found" 
   exit -1
fi


docker exec $contId npm install

