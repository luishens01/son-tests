#!/bin/bash

docker exec -ti son-sp-infrabstract mvn test -Dtest=SP* >> test_results.txt

if grep -q "BUILD SUCCESS" test_results.txt; then
  	echo "SUCCESS"  
else
	echo "Error: lower SP vtu-vnf deployment failed"
    exit -1
fi