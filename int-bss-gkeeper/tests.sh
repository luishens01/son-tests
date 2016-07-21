#!/bin/bash
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
docker rm -fv son-bss
set -x
set -e
docker pull registry.sonata-nfv.eu:5000/son-yo-gen-bss
docker run -d --name son-bss -p 25001:1337 -p 25002:1338 --log-driver=gelf --log-opt gelf-address=udp://10.31.11.37:12900 registry.sonata-nfv.eu:5000/son-yo-gen-bss grunt serve:integration_tests --gkApiUrl=http://sp.int3.sonata-nfv.eu:32001 --suite=unitTests --debug
#docker exec -t -d son-bss grunt protractor_webdriver protractor:run --suite=unit

# -- get the remote reports
x=0
docker cp son-bss:/usr/local/yeoman/SonataBSS/E2E_tests/reports .
while [ "$x" -lt 100 -a ! -e $(pwd)/reports/unitTests.html ]; do
        x=$((x+1))
        sleep 1
		docker cp son-bss:/usr/local/yeoman/SonataBSS/E2E_tests/reports .
done

export DOCKER_HOST="unix:///var/run/docker.sock"
