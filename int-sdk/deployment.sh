#!/bin/bash

#### PREPARE ENVIRONMENT ####
sudo apt-get update
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
#printheader "Deploy SON-EMU"
#docker pull registry.sonata-nfv.eu:5000/son-emu


####################### START CONTAINERS #######################

# run sdk-catalogue services in docker containers
printheader "Run SDK-CATALOGUE"
cd int-sdk-catalogue
docker-compose down
docker-compose up -d
cd ..

# run son-emu in a docker container in the background, expose fake GK and management API
#printheader "Run SON-EMU"
#sudo int-sdk/utils/rm_container.sh son-emu-int-test
#docker run -d -i --name 'son-emu-int-test' --net='host' --pid='host' --privileged='true' \
#    -v '/var/run/docker.sock:/var/run/docker.sock' \
#    -p 5000:5000 \
#    -p 4242:4242 \
#    registry.sonata-nfv.eu:5000/son-emu

# give the emulator time to start and configure
#echo "Wait for emulator"
#sleep 30

#docker exec son-emu-int-test mn --clean
#docker exec -d son-emu-int-test python src/emuvim/examples/sonata_y1_demo_topology_1.py

#echo "Wait for emulator"
#sleep 30


# probe for service platform gatekeeper
printheader "Checking running containers"
docker ps -a

# run son-cli in a docker container
printheader "Run SON-CLI"
int-sdk/utils/rm_container.sh son-cli-int-test
docker run -d -i --name 'son-cli-int-test' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    registry.sonata-nfv.eu:5000/son-cli

# prepare son-cli-int-test container for tests
docker cp int-sdk/tests son-cli-int-test:/
docker exec son-cli-int-test apt-get install -y curl unzip
