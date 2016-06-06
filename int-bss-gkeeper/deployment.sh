#!/bin/bash
#DEPLOYMENT
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"

docker rm -fv $(docker ps -qa)

#PULL THE CONTAINERS
docker pull registry.sonata-nfv.eu:5000/son-yo-gen-bss 
docker pull registry.sonata-nfv.eu:5000/son-gtkpkg 
docker pull registry.sonata-nfv.eu:5000/son-gtksrv 
docker pull registry.sonata-nfv.eu:5000/son-gtkfnct
docker pull registry.sonata-nfv.eu:5000/son-gtkapi 
docker pull registry.sonata-nfv.eu:5000/son-catalogue-repos 

#Databases:
#Postgres
docker run -d -p 5432:5432 --name son-postgres -e POSTGRES_DB=gatekeeper -e POSTGRES_USER=sonatatest -e POSTGRES_PASSWORD=sonata --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 ntboes/postgres-uuid
while ! nc -z sp.int2.sonata-nfv.eu 5432; do
  sleep 1 && echo -n .; # waiting for postgres
done;
#Mongo
docker run -d -p 27017:27017 --name son-mongo --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 mongo
while ! nc -z sp.int2.sonata-nfv.eu 27017; do
  sleep 1 && echo -n .; # waiting for mongo
done;
#Broker 
#Rabbitmq
docker run -d -p 5672:5672 --name son-broker -e RABBITMQ_CONSOLE_LOG=new --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 rabbitmq:3
while ! nc -z sp.int2.sonata-nfv.eu 5672; do
  sleep 1 && echo -n .; # waiting for rabbitmq
done;

#Catalogues
docker run --name son-catalogue-repos -d -p 4002:4011 --add-host mongo:10.31.11.33 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-catalogue-repos
sleep 10
docker run --name son-catalogue-repos1 -i --rm=true --add-host mongo:10.31.11.33 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-catalogue-repos rake init:load_samples[integration]

#Gatekeeper
echo gtkpkg
docker run --name son-gtkpkg -d -p 5100:5100 --add-host sp.int.sonata-nfv.eu:10.31.11.33 -e CATALOGUES_URL=http://sp.int2.sonata-nfv.eu:4002/catalogues -e RACK_ENV=integration --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtkpkg
echo gtksrv
echo populate database
docker run -i -e DATABASE_HOST=sp.int2.sonata-nfv.eu -e RACK_ENV=integration -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest --rm=true --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtksrv bundle exec rake db:migrate
echo 
docker run --name son-gtksrv -d -p 5300:5300 --add-host sp.int.sonata-nfv.eu:10.31.11.33 --add-host jenkins.sonata-nfv.eu:192.168.60.5 --link son-broker --link son-postgres -e RACK_ENV=integration -e DATABASE_HOST=sp.int2.sonata-nfv.eu -e DATABASE_PORT=5432 -e POSTGRES_PASSWORD=sonata -e POSTGRES_USER=sonatatest -e MQSERVER=amqp://guest:guest@10.31.11.33:5672 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtksrv
echo gtkfnct
docker run --name son-gtkfnct -d -p 5500:5500 --add-host sp.int.sonata-nfv.eu:10.31.11.33 --add-host jenkins.sonata-nfv.eu:192.168.60.5 -e RACK_ENV=integration --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtkfnct
echo gtkapi
docker run --name son-gtkapi -d -p 32001:5000 --add-host sp.int.sonata-nfv.eu:10.31.11.33 --link son-gtkpkg --link son-gtksrv -e RACK_ENV=integration -e PACKAGE_MANAGEMENT_URL=http://sp.int2.sonata-nfv.eu:5100 -e SERVICE_MANAGEMENT_URL=http://sp.int2.sonata-nfv.eu:5300 -e FUNCTION_MANAGEMENT_URL=http://sp.int2.sonata-nfv.eu:5500 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-gtkapi 

# -- run catalogue/repositories and gatekeeper containers
#docker-compose -f int-bss-gkeeper/scripts/docker-compose.yml down    
#docker-compose -f int-bss-gkeeper/scripts/docker-compose.yml up -d
#sleep 10
#docker-compose  -f int-bss-gkeeper/scripts/docker-compose.yml run --rm son-gtksrv bundle exec rake db:migrate
#sleep 10

# -- insert NSD/VNFD
int-bss-gkeeper/scripts/postCatalogueSampleDescriptors.sh
int-bss-gkeeper/scripts/postGatekeeperSampleRequest.sh
sleep 5

# -- BSS
if ! [[ "$(docker inspect -f {{.State.Running}} son-bss 2> /dev/null)" == "" ]]; then docker rm -fv son-bss ; fi
#docker run -d --name son-bss -p 25001:1337 -p 25002:1338 -it registry.sonata-nfv.eu:5000/son-yo-gen-bss
docker run -d --name son-bss -p 25001:1337 -p 25002:1338 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-yo-gen-bss grunt serve:integration --gkApiUrl=http://sp.int2.sonata-nfv.eu:32001 --debug

export DOCKER_HOST="unix:///var/run/docker.sock"