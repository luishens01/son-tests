#!/bin/bash

resp=$(curl -s -X POST http://sp.int3.sonata-nfv.eu:8000/api/v1/service/new -d @resources/data.json -H "Accept: application/json" -H "Content-Type: application/json")

if [[ $(echo $resp | python -mjson.tool | grep "success") != *"success"* ]] ;
  then
    echo "Error: New Service Post action FAILED ($resp)"
    exit -1 
fi

resp=$(curl -s http://sp.int3.sonata-nfv.eu:8000/api/v1/services)

srvs=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print len(obj["results"])')
if [[ "$srvs" -gt 0 ]];
  then
  index=0
  while [  $index -lt $srvs ]; do
     srv_name=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["results"]['$index']["sonata_srv_id"]')
     if [[ $srv_name == "TEST_NS859674" ]] ;
	then
	id=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["results"]['$index']["id"]')
	echo "Success: New Service Post action done"
        curl -X DELETE http://sp.int3.sonata-nfv.eu:8000/api/v1/service/$id/
	exit 1
     fi		
     let index=index+1 
  done
fi

echo "Error: New Service didn't found"