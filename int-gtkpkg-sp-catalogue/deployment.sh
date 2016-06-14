#!/bin/bash
###WORK IN PROGRESS
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

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
sleep 5

# populate gtksrv database
docker run -i -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e MQSERVER=amqp://guest:guest@sp.int3.sonata-nfv.eu:5672 -e RACK_ENV=integration -e CATALOGUES_URL=http://sp.int3.sonata-nfv.eu:4002/catalogues -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtksrv bundle exec rake db:migrate

export DOCKER_HOST="unix:///var/run/docker.sock"
