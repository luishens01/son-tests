#!/bin/bash

status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:8000/api/v1/prometheus/metrics/list)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1 
fi

resp=$(curl -s http://sp.int3.sonata-nfv.eu:8000/api/v1/prometheus/metrics/list)

vm_mtc=$(echo $resp | python -mjson.tool | grep "vm_cpu_perc")
cnt_mtc=$(echo $resp | python -mjson.tool | grep "cnt_mem_perc")

if [ -z "$vm_mtc" ];
 then
   echo "Error: Metrics for vms missing" 
   exit -1
fi

if [ -z "$vm_mtc" ];
 then
   echo "Error: Metrics for containers missing" 
   exit -1
fi

echo "Success: Metrics from service platform found"

