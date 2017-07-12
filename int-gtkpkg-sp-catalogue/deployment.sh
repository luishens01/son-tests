#!/bin/bash

#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

# MONGODB (CATALOGUE-REPOS)
# Clean database
# Removing
docker rm -fv son-mongo 
sleep 5
# Starting
docker run -d -p 27017:27017 --name son-mongo --net=sonata --network-alias=son-mongo --log-driver=gelf --log-opt gelf-address=udp://10.30.0.219:12900 mongo
while ! nc -z sp.int3.sonata-nfv.eu 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;

# POSTGRES (GATEKEEPER)
# Clean database
# Removing
# docker rm -fv son-postgres
# sleep 5
# Starting
# docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=gatekeeper -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata ntboes/postgres-uuid
# while ! nc -z sp.int3.sonata-nfv.eu 5432; do
#   sleep 1 && echo -n .; # waiting for postgres
# done;
# sleep 5

# populate gtksrv database
# docker run -i -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e MQSERVER=amqp://guest:guest@sp.int3.sonata-nfv.eu:5672 -e RACK_ENV=integration -e CATALOGUES_URL=http://sp.int3.sonata-nfv.eu:4002/catalogues/api/v2 -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtksrv bundle exec rake db:migrate
# sleep 5
# docker run -i -e DATABASE_HOST=sp.int3.sonata-nfv.eu -e MQSERVER=amqp://guest:guest@sp.int3.sonata-nfv.eu:5672 -e RACK_ENV=integration -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtkvim bundle exec rake db:migrate
# docker rm -fv son-sp-infrabstract
# sleep 2
# docker run -d --name son-sp-infrabstract -e broker_host=10.31.11.36 -e broker_uri=amqp://guest:guest@10.31.11.36:5672/%2F -e repo_host=sp.int3.sonata-nfv.eu -e repo_port=5432 -e repo_user=sonatatest -e repo_pass=sonata --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900  registry.sonata-nfv.eu:5000/son-sp-infrabstract /docker-entrypoint.sh
# sleep 5

export DOCKER_HOST="unix:///var/run/docker.sock"
