#!/bin/bash

resp=$(curl -s -X POST http://sp.int3.sonata-nfv.eu:8000/api/v1/service/new -d @int-mon/resources/new_srv_slm.json -H "Accept: application/json" -H "Content-Type: application/json")

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
  srv_found=0
  while [  $index -lt $srvs ]; do
    srv_name=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["results"]['$index']["sonata_srv_id"]')
    if [[ $srv_name == "005606ed-be7d-4ce3-983c-847039e3a5a3" ]] ;
      then
      id=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["results"]['$index']["id"]')
      srv_found=1
      echo "Success: New Service Post action done"
      curl -s -X DELETE http://sp.int3.sonata-nfv.eu:8000/api/v1/service/$id/
    fi		
    let index=index+1 
  done
fi

if [[ $srv_found -eq 0 ]] ;
  then
  echo "Error: New Service didn't found"
  exit -1
fi