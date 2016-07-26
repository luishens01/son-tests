#!/bin/bash
set -x
set -e

message=$(curl -H "Content-Type: application/json" -X GET "http://sp.int3.sonata-nfv.eu:32001/services")
# info: get last occurrence of "uuid: \""
message=$(echo $message| awk -F"\"uuid\":\"" '{print $NF}')
# info: get UUID
uuid=${SERVICES:0:36}

printf "\n\n======== Insert request  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST --data-binary '{"service_uuid":"'$uuid'"}' http://sp.int3.sonata-nfv.eu:32001/requests)
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

service=$(echo "$resp" | head -n-1)
echo "Body: $service"

echo $code

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
  exit -1
fi
