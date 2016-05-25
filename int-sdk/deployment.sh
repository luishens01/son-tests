#!/bin/bash

#### PREPARE ENVIRONMENT ####

set -xe

export DOCKER_HOST="unix:///var/run/docker.sock"
echo DOCKER_OPTS=\"--insecure-registry registry.sonata-nfv.eu:5000 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375\" | sudo tee /etc/default/docker
sudo service docker restart
docker login -u sonata-nfv -p s0n@t@ registry.sonata-nfv.eu:5000


#### DEPLOY SON-CLI ####

docker pull registry.sonata-nfv.eu:5000/son-cli



#### DEPLOY SON-CATALOGUE

echo "\n\n======= Deploy SON-CATALOGUE =======\n\n"

docker pull registry.sonata-nfv.eu:5000/sdk-catalogue
cd int-sdk-catalogue
docker-compose down
docker-compose up -d


#### DEPLOY SON-EMU ####

echo "\n\n======= Deploy SON-EMU =======\n\n"

sudo docker pull registry.sonata-nfv.eu:5000/son-emu

# run son-emu in a docker container in the background, expose fake GK and management API
sudo docker run -d -i --name 'son-emu-int-test' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    -p 5000:5000 \
    -p 4242:4242 \
    registry.sonata-nfv.eu:5000/son-emu 'python src/emuvim/examples/sonata_y1_demo_topology_1.py'




