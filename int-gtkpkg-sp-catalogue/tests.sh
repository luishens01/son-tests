#!/bin/bash

###WORK IN PROGRESS
# Contact Catalogues-DB
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:27017/)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi

echo "Success: Catalogues-DB found"

# Clean Catalogues
printf "\n\n======== Cleaning SP Catalogues ========\n\n\n"
#scripts/clean-catalogue-server.sh???

# Contact Gatekeeper
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:32001/)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi

echo "Success: Gatekeeper found"

#
printf "\n\n======== POST Service to Gatekeeper ========\n\n\n"
resp=$(curl -H "Content-Type: application/json" -X POST http://sp.int3.sonata-nfv.eu:32001/services)
echo $resp

service=$(echo $resp | grep "uuid")

#
printf "\n\n======== GET Service from Gatekeeper  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X GET http://sp.int3.sonata-nfv.eu:32001/services) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

service=$(echo "$resp" | head -n-1)
echo "Body: $service"

uuid=$(echo $service  |  python -mjson.tool | grep "uuid" | awk -F'[=:]' '{print $2}' | sed 's/\"//g' | tr -d ',')
echo "UUID: $uuid"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

#
printf "\n\n======== POST Function to Gatekeeper  ========\n\n\n"
resp=$(curl -H "Content-Type: application/json" -X POST http://sp.int3.sonata-nfv.eu:32001/functions)
echo $resp

#
printf "\n\n======== GET Function from Gatekeeper  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X GET http://sp.int3.sonata-nfv.eu:32001/functions) 2>/dev/null
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

#echo "Success"