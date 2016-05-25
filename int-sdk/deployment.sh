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
docker pull registry.sonata-nfv.eu:5000/sdk-catalogue


#### DEPLOY SON-EMU ####
sudo docker pull registry.sonata-nfv.eu:5000/son-emu



