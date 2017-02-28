#!/bin/bash
printf "\n\n======== GET all sonata KPIs ========\n\n\n"

# Get the KPIs
resp=$(curl -H 'Content-Type: application/json' -X GET http://sp.int3.sonata-nfv.eu:32001/api/v2/kpis)
kpis_len=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print len(obj["results"])')
if [[ "$srvs" -gt 0 ]];

# KPIs list size
counter_value=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["data"]')
echo "There are "+$counter_value+" registered KPIs in the system"

if [[$counter_value -lt 2]] ;
	then
		echo "Error: Counter did not be incremented"
		exit -1
fi