#!/bin/bash
set -x
set -e

# -- insert NSD
printf "\n\n======== Insert NSD  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST --data-binary @int-bss-gkeeper/resources/NSD.json http://sp.int3.sonata-nfv.eu:4002/catalogues/network-services) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

service=$(echo "$resp" | head -n-1)
echo "Body: $service"

echo $code

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
  exit -1
fi

# -- insert VNFD
printf "\n\n======== Insert VNFD  ========\n\n\n"
resp1=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST --data-binary @int-bss-gkeeper/resources/VNFD.json http://sp.int3.sonata-nfv.eu:4002/catalogues/vnfs) 2>/dev/null
echo $resp1

code1=$(echo "$resp" | tail -n1)
echo "Code: $code1"

service1=$(echo "$resp1" | head -n-1)
echo "Body: $service1"

if [[ $code1 != 200 ]] ;
  then
    echo "Error: Response error $code"
  exit -1
fi
