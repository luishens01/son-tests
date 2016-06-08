#!/bin/bash

###WORK IN PROGRESS

#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"

# pull GATEKEEPER containers
docker pull registry.sonata-nfv.eu:5000/son-gtkapi
docker pull registry.sonata-nfv.eu:5000/son-gtkpkg
docker pull registry.sonata-nfv.eu:5000/son-gtksrv

# pull CATALOGUE-REPOS containers
docker pull registry.sonata-nfv.eu:5000/son-catalogue-repos
#docker-compose down
#docker-compose up -d

# MONGODB (CATALOGUE-REPOS)
docker run -d -p 27017:27017 --name son-mongo mongo
while ! nc -z sp.int2.sonata-nfv.eu 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;

# POSTGRES (GATEKEEPER)
docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=gatekeeper -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata ntboes/postgres-uuid
while ! nc -z sp.int2.sonata-nfv.eu 5432; do
  sleep 1 && echo -n .; # waiting for postgres
done;

# run CATALOGUE-REPOS
docker run --name son-catalogue-repos -d -p 4002:4011 --add-host mongo:10.31.11.33 registry.sonata-nfv.eu:5000/son-catalogue-repos
sleep 10
docker run --name son-catalogue-repos1 -i --rm=true --add-host mongo:10.31.11.33 registry.sonata-nfv.eu:5000/son-catalogue-repos rake init:load_samples[integration]

# run GATEKEEPER
echo gtkpkg
docker run --name son-gtkpkg -d -p 5100:5100 --add-host sp.int.sonata-nfv.eu:10.31.11.33 -e RACK_ENV=integration registry.sonata-nfv.eu:5000/son-gtkpkg
echo gtksrv
## echo populate database
docker run -i -e DATABASE_HOST=sp.int2.sonata-nfv.eu -e RACK_ENV=integration -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true registry.sonata-nfv.eu:5000/son-gtksrv bundle exec rake db:migrate
echo
docker run --name son-gtksrv -d -p 5300:5300 --add-host sp.int.sonata-nfv.eu:10.31.11.33 --add-host jenkins.sonata-nfv.eu:192.168.60.5 --link son-broker --link son-postgres -e RACK_ENV=integration -e DATABASE_HOST=sp.int2.sonata-nfv.eu -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest -e MQSERVER=amqp://guest:guest@10.31.11.33:5672 registry.sonata-nfv.eu:5000/son-gtksrv
echo gtkapi
docker run --name son-gtkapi -d -p 32001:5000 --add-host sp.int.sonata-nfv.eu:10.31.11.33 --link son-gtkpkg --link son-gtksrv -e RACK_ENV=integration -e PACKAGE_MANAGEMENT_URL=http://sp.int2.sonata-nfv.eu:5100 -e SERVICE_MANAGEMENT_URL=http://sp.int2.sonata-nfv.eu:5300 registry.sonata-nfv.eu:5000/son-gtkapi

# -- run CATALOGUE-REPOS and GATEKEEPER containers
#docker-compose -f int-gtkpkg-sp-catalogue/scripts/docker-compose.yml down
#docker-compose -f int-gtkpkg-sp-catalogue/scripts/docker-compose.yml up -d
#sleep 10
#docker-compose  -f int-gtkpkg-sp-catalogue/scripts/docker-compose.yml run --rm son-gtksrv bundle exec rake db:migrate
#sleep 10

# -- insert/retrieve NSD/VNFD
#int-gtkpkg-sp-catalogue/scripts/postGatekeeperSampleRequest.sh
#int-gtkpkg-sp-catalogue/scripts/getGatekeeperSampleRequest.sh
#sleep 5

# -- GTK API
#if ! [[ "$(docker inspect -f {{.State.Running}} int-son-gtkapi 2> /dev/null)" == "" ]]; then docker rm -f int-son-gtkapi ; fi
#docker run -d -p 42001:5000 --name int-son-gtkapi registry.sonata-nfv.eu:5000/son-gtkapi

export DOCKER_HOST="unix:///var/run/docker.sock"