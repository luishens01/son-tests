#!/bin/bash
###WORK IN PROGRESS
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

# pull GATEKEEPER containers
docker pull registry.sonata-nfv.eu:5000/son-gtkapi
docker pull registry.sonata-nfv.eu:5000/son-gtkpkg
docker pull registry.sonata-nfv.eu:5000/son-gtksrv

# pull CATALOGUE-REPOS containers
docker pull registry.sonata-nfv.eu:5000/son-catalogue-repos

# MONGODB (CATALOGUE-REPOS)
# Clean database
# Removing
docker rm -fv son-mongo 
sleep 5
# Starting
docker run -d -p 27017:27017 --name son-mongo mongo
while ! nc -z sp.int3.sonata-nfv.eu 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;

# POSTGRES (GATEKEEPER)
# Clean database
# Removing
docker rm -fv son-postgres
sleep 5
# Starting
docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=gatekeeper -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata ntboes/postgres-uuid
while ! nc -z sp.int3.sonata-nfv.eu 5432; do
  sleep 1 && echo -n .; # waiting for postgres
done;

# run GATEKEEPER
# Removing gtkapi
docker rm -fv son-gtkapi
# Removing son-gtkpkg
docker rm -fv son-gtkpkg
# Removing son-gtksrv
docker rm -fv son-gtksrv
sleep 10
# son-gtkpkg
# Starting son-gtkpkg
docker run --name son-gtkpkg -d -p 5100:5100 --add-host sp.int.sonata-nfv.eu:10.31.11.36 -e CATALOGUES_URL=http://sp.int3.sonata-nfv.eu:4002/catalogues -e RACK_ENV=integration --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtkpkg
# son-gtksrv
# populate gtksrv database
docker run -i -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e MQSERVER=amqp://guest:guest@sp.int3.sonata-nfv.eu:5672 -e RACK_ENV=integration -e CATALOGUES_URL=http://sp.int3.sonata-nfv.eu:4002/catalogues -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtksrv bundle exec rake db:migrate
# Starting son-gtksrv
docker run --name son-gtksrv -d -p 5300:5300 -e MQSERVER=amqp://guest:guest@sp.int3.sonata-nfv.eu:5672 --add-host sp.int.sonata-nfv.eu:10.31.11.36 -e CATALOGUES_URL=http://sp.int3.sonata-nfv.eu:4002/catalogues --add-host jenkins.sonata-nfv.eu:10.31.11.36 --link son-broker --link son-postgres -e RACK_ENV=integration -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest -e MQSERVER=amqp://guest:guest@10.31.11.36:5672 -e RACK_ENV=integration --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtksrv
# son-gtkapi
# Starting gtkapi
docker run --name son-gtkapi -d -p 32001:5000 --add-host sp.int.sonata-nfv.eu:10.31.11.36 --link son-gtkpkg --link son-gtksrv -e RACK_ENV=integration -e PACKAGE_MANAGEMENT_URL=http://sp.int3.sonata-nfv.eu:5100 -e SERVICE_MANAGEMENT_URL=http://sp.int3.sonata-nfv.eu:5300 -e FUNCTION_MANAGEMENT_URL=http://sp.int3.sonata-nfv.eu:5500 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtkapi 

# run CATALOGUE-REPOS
# Removing son-catalogue-repos
docker rm -fv son-catalogue-repos
sleep 5
# Starting son-catalogue-repos
docker run --name son-catalogue-repos -d -p 4002:4011 --add-host mongo:10.31.11.36 registry.sonata-nfv.eu:5000/son-catalogue-repos
sleep 15

#docker run --name son-catalogue-repos1 -i --rm=true --add-host mongo:10.31.11.33 registry.sonata-nfv.eu:5000/son-catalogue-repos rake init:load_samples[integration]


# -- insert/retrieve NSD/VNFD
#int-gtkpkg-sp-catalogue/scripts/postGatekeeperSampleRequest.sh
#int-gtkpkg-sp-catalogue/scripts/getGatekeeperSampleRequest.sh
#sleep 5

# -- GTK API
#if ! [[ "$(docker inspect -f {{.State.Running}} int-son-gtkapi 2> /dev/null)" == "" ]]; then docker rm -f int-son-gtkapi ; fi
#docker run -d -p 42001:5000 --name int-son-gtkapi registry.sonata-nfv.eu:5000/son-gtkapi

export DOCKER_HOST="unix:///var/run/docker.sock"
