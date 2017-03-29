#!/bin/bash
set -e
set -x

#### PREPARE ENVIRONMENT ####
sudo apt-get update -y -qq
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y git realpath
sudo ln -sf $(realpath ../int-sdk/utils/print-header.sh) /usr/bin/printheader
printheader "Prepare Environment"
sudo apt-get remove -y docker docker-engine || true
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y -qq
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y docker-ce

export DOCKER_HOST="unix:///var/run/docker.sock"
mkdir -p /tmp/workspace
rm -rf /tmp/workspace/*


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
    -v "$(pwd)/utils/W:/usr/local/bin/W" \
    -v "$(pwd)/utils/Cmd:/usr/local/bin/Cmd" \
    -v "$(pwd)/../int-sdk/utils/print-header.sh:/usr/local/bin/printheader" \
    -p 5000:5000 \
    -p 4242:4242 \
    registry.sonata-nfv.eu:5000/son-emu
docker exec son-emu-int-sdk-pipeline apt-get update -y -qq
docker exec son-emu-int-sdk-pipeline apt-get install -y screen coreutils
docker exec son-emu-int-sdk-pipeline ls -lrth /usr/local/bin

# run son-cli in a docker container
printheader "Run SON-CLI"
docker rm -f son-cli-int-test || true
docker run -d -i --name 'son-cli-int-test' --workdir '/tmp/workspace' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    -v '/tmp/workspace:/tmp/workspace' \
    registry.sonata-nfv.eu:5000/son-cli
docker exec son-cli-int-test rm -rf /root/.son-workspace
docker exec son-cli-int-test son-workspace --init
docker exec son-cli-int-test son-access config --platform_id emu --new --url http://127.0.0.1:5000 --default

# print state
printheader "(Info) State"
docker ps -a
docker ps -q | xargs -L 1 docker top
