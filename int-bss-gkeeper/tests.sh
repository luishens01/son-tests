#!/bin/bash
export DOCKER_HOST="tcp://sp.int2.sonata-nfv.eu:2375"
docker exec -t -d son-bss grunt serve:integration_tests --suite=intBSS_GK

# -- get the remote reports
x=0
scp -rp jenkins@sp.int2.sonata-nfv.eu:/var/lib/jenkins/jobs/int-bss-gkeeper/workspace/int-bss-gkeeper/reports/htmlReport.html htmlReport.html
while [ "$x" -lt 100 -a ! -e $(pwd)/reports/htmlReport.html ]; do
        x=$((x+1))
		scp -rp jenkins@sp.int2.sonata-nfv.eu:/var/lib/jenkins/jobs/int-bss-gkeeper/workspace/int-bss-gkeeper/reports/htmlReport.html htmlReport.html
        sleep 1
done
scp -rp jenkins@sp.int2.sonata-nfv.eu:/var/lib/jenkins/jobs/int-bss-gkeeper/workspace/int-bss-gkeeper/reports/screenshots screenshots


export DOCKER_HOST="unix:///var/run/docker.sock"
