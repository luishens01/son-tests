#!/bin/bash

#resp=$(curl -s -X POST http://192.168.1.50:8000/api/v1/service/new -d @int-mon/resources/new_srv_slm.json -H "Accept: application/json" -H "Content-Type: application/json")

#if [[ $(echo $resp | python -mjson.tool | grep "success") != *"success"* ]] ;
#  then
#    echo "Error: New Service Post action FAILED ($resp)"
#    exit -1 
#fi


resp=$(curl -s -X POST http://192.168.1.50:9091/metrics/job/vnf/instance/INT_TEST_VM --data-binary @int-mon/resources/test_mon_data.txt -H "Content-Type: text/html")

print $resp