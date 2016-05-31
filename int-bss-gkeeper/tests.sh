#!/bin/bash
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"
docker exec -t -d son-bss grunt serve:integration_tests --gkApiUrl=http://sp.int2.sonata-nfv.eu:32001 --suite=intBSS_GK

# -- get the remote reports
x=0
docker cp son-bss:/usr/local/yeoman/SonataBSS/E2E_tests/reports .
while [ "$x" -lt 100 -a ! -e $(pwd)/reports/htmlReport.html ]; do
        x=$((x+1))		
        sleep 1
		docker cp son-bss:/usr/local/yeoman/SonataBSS/E2E_tests/reports .
done

export DOCKER_HOST="unix:///var/run/docker.sock"
