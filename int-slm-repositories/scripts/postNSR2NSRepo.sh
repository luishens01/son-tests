#!/bin/bash

printf "\n\n======== POST NSR to NS repository ========\n\n\n"
# -- POST NSR to NS repository
# curl -H "Content-Type: application/json" -X  POST --d @int-slm-repositories/resources/nsr.json http://api.int.sonata-nfv.eu:4002/records/nsr/ns-instances
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST --d @int-slm-repositories/resources/nsr.json http://api.int.sonata-nfv.eu:4002/records/nsr/ns-instances)
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi
