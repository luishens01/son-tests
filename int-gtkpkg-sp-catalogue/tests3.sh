#!/bin/bash
#
printf "\n\n======== GET Function from Gatekeeper  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X GET http://sp.int.sonata-nfv.eu:32001/functions?fields=uuid,name,version,vendor) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

function=$(echo "$resp" | head -n-1)
echo "Body: $function"

uuid=$(echo $function  |  python -mjson.tool | grep "uuid" | awk -F'[=:]' '{print $2}' | sed 's/\"//g' | tr -d ',')
echo "UUID: $uuid"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi
