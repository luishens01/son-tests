#!/bin/bash

tw_end=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
tw_start=$(date -u -d -10minutes '+%Y-%m-%dT%H:%M:%SZ')
resp=$(curl \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data '{"name":"vm_mem_perc","start": "'$tw_start'", "end": "'$tw_end'", "step": "20m", "labels": [{"labeltag":"exported_job", "labelid":"vnf"}]}' "http://sp.int3.sonata-nfv.eu:8000/api/v1/prometheus/metrics/data" )

job=$(echo $resp | python -mjson.tool | grep "exported_job")

instance=$(echo $resp | python -mjson.tool | grep "exported_instance")

if [[ $job =~ .*vnf.* ]]
then
	if [[ $instance =~ .*test-mon-vnf.* ]]
	then
	   echo "Success: TEST VNF(VM) FOUND!"
	else
	   echo "Error: TEST VNF(VM) NOT FOUND"
	fi    
else
   echo "Error: No monitoring data for vnfs!!"
fi
