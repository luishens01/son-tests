#!/bin/bash

#Send TEST RULE
resp=$(curl -s -X POST http://sp.int3.sonata-nfv.eu:8000/api/v1/service/new -d @int-mon/resources/new_srv_slm.json -H "Accept: application/json" -H "Content-Type: application/json")

#Send CPU Overload signal for test VNF with 0123456789
curl -s -X POST http://sp.int3.sonata-nfv.eu:9091/metrics/job/vnf/instance/INT_TEST_VM --data-binary @int-mon/resources/vnf_cpu_overload.txt -H "Content-Type: text/html"

#Connect to son-broker and wait for alert notification
resp=$(python int-mon/tests/checkQueue.py)

#Erase overload signal
curl -s -X POST http://sp.int3.sonata-nfv.eu:9091/metrics/job/vnf/instance/INT_TEST_VM --data-binary @int-mon/resources/vnf_cpu_normal.txt -H "Content-Type: text/html"

#Return status
if [ $resp = "True" ]; 
 then
   echo "Success: Alert Notification arrived"
 else
   echo "Error: Notification not found"
   exit -1
fi

