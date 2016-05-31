#!/bin/bash
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"

# -- run catalogue/repositories and gatekeeper containers
docker-compose -f int-gtkpkg-sp-catalogue/scripts/docker-compose.yml down
docker-compose -f int-gtkpkg-sp-catalogue/scripts/docker-compose.yml up -d
sleep 10
docker-compose  -f int-gtkpkg-sp-catalogue/scripts/docker-compose.yml run --rm son-gtksrv bundle exec rake db:migrate
sleep 10

# -- insert NSD/VNFD
#int-gtkpkg-sp-catalogue/scripts/postCatalogueSampleDescriptors.sh
#int-gtkpkg-sp-catalogue/scripts/postGatekeeperSampleRequest.sh
#sleep 5

# -- BSS
#if ! [[ "$(docker inspect -f {{.State.Running}} son-bss 2> /dev/null)" == "" ]]; then docker rm -fv son-bss ; fi
#docker run -d --name son-bss -p 25001:1337 -p 25002:1338 -it registry.sonata-nfv.eu:5000/son-yo-gen-bss

export DOCKER_HOST="unix:///var/run/docker.sock"

#OLD JENKINS SCRIPT
##!/bin/bash
##DEPLOYMENT SCRIPT
#export DOCKER_HOST="tcp://192.168.60.25:2375"
## -- catalogue/repos
##docker pull registry.sonata-nfv.eu:5000/son-catalogue-repos
##docker-compose down
##docker-compose up -d
## -- Gatekeeper
#docker pull registry.sonata-nfv.eu:5000/son-gtkapi
#docker pull registry.sonata-nfv.eu:5000/son-gtkpkg
#docker pull registry.sonata-nfv.eu:5000/son-gtksrv
#if ! [[ "$(docker inspect -f {{.State.Running}} int-son-gtkapi 2> /dev/null)" == "" ]]; then docker rm -f int-son-gtkapi ; fi
#docker run -d -p 42001:5000 --name int-son-gtkapi registry.sonata-nfv.eu:5000/son-gtkapi
## -- BSS
#docker pull registry.sonata-nfv.eu:5000/son-yo-gen-bss
#if ! [[ "$(docker inspect -f {{.State.Running}} int-son-bss 2> /dev/null)" == "" ]]; then docker rm -f int-son-bss ; fi
#docker run -d --name int-son-bss -p 25002:1337 registry.sonata-nfv.eu:5000/son-yo-gen-bss grunt serve:integration
#export DOCKER_HOST="unix:///var/run/docker.sock"