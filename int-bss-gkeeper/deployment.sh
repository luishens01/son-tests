#!/bin/bash
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"

#PULL THE CONTAINERS
docker pull registry.sonata-nfv.eu:5000/son-yo-gen-bss 
docker pull registry.sonata-nfv.eu:5000/son-gtkpkg 
docker pull registry.sonata-nfv.eu:5000/son-gtksrv 
docker pull registry.sonata-nfv.eu:5000/son-gtkapi 
docker pull registry.sonata-nfv.eu:5000/son-catalogue-repos 

# -- run catalogue/repositories and gatekeeper containers
docker-compose -f int-bss-gkeeper/scripts/docker-compose.yml down    
docker-compose -f int-bss-gkeeper/scripts/docker-compose.yml up -d
sleep 10
docker-compose  -f int-bss-gkeeper/scripts/docker-compose.yml run --rm son-gtksrv bundle exec rake db:migrate
sleep 10

# -- insert NSD/VNFD
int-bss-gkeeper/scripts/postCatalogueSampleDescriptors.sh
int-bss-gkeeper/scripts/postGatekeeperSampleRequest.sh
sleep 5

# -- BSS
if ! [[ "$(docker inspect -f {{.State.Running}} son-bss 2> /dev/null)" == "" ]]; then docker rm -fv son-bss ; fi
#docker run -d --name son-bss -p 25001:1337 -p 25002:1338 -it registry.sonata-nfv.eu:5000/son-yo-gen-bss
docker run -d --name son-bss -p 25001:1337 -p 25002:1338 registry.sonata-nfv.eu:5000/son-yo-gen-bss grunt serve:integration --gkApiUrl=http://sp.int2.sonata-nfv.eu:32001

export DOCKER_HOST="unix:///var/run/docker.sock"