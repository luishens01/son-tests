#!/bin/bash
set -e
set -x

#### PREPARE ENVIRONMENT ####
sudo apt-get update -y -qq
sudo apt-get install -y git realpath
sudo ln -sf $(realpath ../int-sdk/utils/print-header.sh) /usr/bin/printheader

printheader "Prepare Environment"
sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y build-essential python-dev python-pip docker-engine



export DOCKER_HOST="unix:///var/run/docker.sock"
docker login -u sonata-nfv -p s0n@t@ registry.sonata-nfv.eu:5000


#### FETCH SON-CLI ####
printheader "Deploy SON-CLI"
docker pull registry.sonata-nfv.eu:5000/son-cli


#### FETCH SON-EMU ####
printheader "Deploy SON-EMU"
docker pull registry.sonata-nfv.eu:5000/son-emu


####################### START CONTAINERS #######################

# run son-emu in a docker container in the background, expose fake GK and management API
printheader "Run SON-EMU"
docker rm -f son-emu-int-sdk-pipeline || true
docker run -d -i --name 'son-emu-int-sdk-pipeline' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    -v "$(pwd)/utils/W:/usr/bin/W" \
    -v "$(pwd)/utils/Cmd:/usr/bin/Cmd" \
    -p 5000:5000 \
    -p 4242:4242 \
    registry.sonata-nfv.eu:5000/son-emu

# run son-cli in a docker container
printheader "Run SON-CLI"
docker rm -f son-cli-int-test || true
docker run -d -i --name 'son-cli-int-test' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    registry.sonata-nfv.eu:5000/son-cli
