#!/bin/bash

printf "\n\n======== POST NSR/VNFR to Monitoring Repository ========\n\n\n"
# -- Post NSR/VNFR to Monitoring Repository
#curl -H "Content-Type: application/json" -X POST http://sp.int2.sonata-nfv.eu:800/api/v1/service/new -d @int-slm-repositories/resources/monitoring-message.json
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST -d @int-slm-repositories/resources/monitoring-message.json http://sp.int3.sonata-nfv.eu:8000/api/v1/service/new)
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 20* ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi
