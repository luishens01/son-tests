#!/bin/bash

printf "\n\n======== POST VNFR to VNF repository ========\n\n\n"
# -- insert VNFR
# curl -H "Content-Type: application/json" -X POST -d @int-slm-repositories/resources/vnfr.json http://api.int.sonata-nfv.eu:4002/records/vnfr/vnf-instances
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST --d @int-slm-repositories/resources/vnfr.json http://api.int.sonata-nfv.eu:4002/records/vnfr/vnf-instances)
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi
