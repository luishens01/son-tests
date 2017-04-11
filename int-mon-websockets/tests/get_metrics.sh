#!/bin/bash

#Check server
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:8000/api/v1/prometheus/metrics/list)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1 
fi


#Get metric list
resp=$(curl -s 'http://sp.int3.sonata-nfv.eu:8000/api/v1/prometheus/metrics/list')

metrics=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print len(obj["metrics"])')

if [[ "$metrics" -gt 0 ]];
  then
  index=0
  metric_found=0
  while [  $index -lt $metrics ]; do
    metric_name=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["metrics"]['$index']')
    if [[ $metric_name = "vm_cpu_perc" ]] ; then

    	metric_found=1
    	break
    fi	
    let index=index+1 
  done
fi


if [[ "$metric_found" -eq 0 ]];
 then
   echo "Error: Metric vm_cpu_perc not found" 
   exit -1
fi

echo "Success: Metric vm_cpu_perc found!!"