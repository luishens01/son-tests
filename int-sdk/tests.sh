#!/bin/bash

set -xe


# run sdk-catalogue services in docker containers
printheader "Run SDK-CATALOGUE"
cd int-sdk-catalogue
docker-compose down
docker-compose up -d
cd ..

docker ps -a


# run son-emu in a docker container in the background, expose fake GK and management API
printheader "Run SON-EMU"
sudo int-sdk/scripts/rm_container.sh son-emu-int-test
sudo docker run -d -i --name 'son-emu-int-test' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    -p 5000:5000 \
    -p 4242:4242 \
    registry.sonata-nfv.eu:5000/son-emu

# give the emulator time to start and configure
echo "Wait for emulator"
sleep 30

sudo docker exec son-emu-int-test mn --clean
sudo docker exec -d son-emu-int-test python src/emuvim/examples/sonata_y1_demo_topology_1.py

echo "Wait for emulator"
sleep 30


# run son-cli in a docker container
printheader "Run SON-CLI"
sudo int-sdk/scripts/rm_container.sh son-cli-int-test
sudo docker run -d -i --name 'son-cli-int-test' --net='host' --pid='host' --privileged='true' \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    registry.sonata-nfv.eu:5000/son-cli

# prepare son-cli-int-test container for tests
sudo docker cp int-sdk son-cli-int-test:/
sudo docker exec son-cli-int-test apt-get install -y curl unzip



# execute tests
printheader "EXECUTE INTEGRATION TESTS"
sudo docker exec son-cli-int-test /bin/bash -c 'cd /int-sdk; ./run-tests.sh'


# do some clean up
