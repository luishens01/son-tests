#!/bin/bash

# run sdk-catalogue services in docker containers
cd int-sdk-catalogue
docker-compose down
docker-compose up -d

# run son-emu in a docker container in the background, expose fake GK and management API
sudo docker run -d -i --name 'son-emu-int-test' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    -p 5000:5000 \
    -p 4242:4242 \
    registry.sonata-nfv.eu:5000/son-emu 'python src/emuvim/examples/sonata_y1_demo_topology_1.py'


# run son-cli in a docker container
sudo docker run -d -i --name 'son-cli-int-test' --net='host' --pid='host' registry.sonata-nfv.eu:5000/son-cli
docker cp int-sdk son-cli-int-test:/

## next step -> docker exec ... to perform the tests!
