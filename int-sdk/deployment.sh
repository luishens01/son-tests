#!/bin/bash

#### PREPARE ENVIRONMENT ####
sudo apt-get install realpath
sudo ln -sf $(realpath int-sdk/utils/print-header.sh) /usr/bin/printheader

printheader "Prepare Environment"
sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y build-essential python-dev python-pip docker-engine
sudo pip install flask  # for son-emu - not sure why flask always makes trouble when installed from setup.py

export DOCKER_HOST="unix:///var/run/docker.sock"
echo DOCKER_OPTS=\"--insecure-registry registry.sonata-nfv.eu:5000 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375\" | sudo tee /etc/default/docker
sudo service docker restart
docker login -u sonata-nfv -p s0n@t@ registry.sonata-nfv.eu:5000


#### DEPLOY SON-CLI ####
printheader "Deploy SON-CLI"
docker pull registry.sonata-nfv.eu:5000/son-cli


#### DEPLOY SON-CATALOGUE
printheader "Deploy SON-CATALOGUE"
docker pull registry.sonata-nfv.eu:5000/sdk-catalogue


#### DEPLOY SON-EMU ####
printheader "Deploy SON-EMU"
sudo docker pull registry.sonata-nfv.eu:5000/son-emu


#### DEPLOY SP ####
printheader "Deploy SERVICE PLATFORM"
cd int-sp-instantiation
./deployment.sh
cd ..
