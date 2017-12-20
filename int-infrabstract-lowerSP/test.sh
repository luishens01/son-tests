#!/bin/bash
set -x
set -e
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"

docker exec -i son-sp-infrabstract mvn test -Dtest=SP* >> test_results.txt

cat test_results.txt

if grep -q "BUILD SUCCESS" test_results.txt; then
  	echo "SUCCESS"  
else
	echo "Error: lower SP vtu-vnf deployment failed"
    exit -1
fi