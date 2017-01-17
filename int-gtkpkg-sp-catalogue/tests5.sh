#!/bin/bash
#printf "\n\n======== POST SON Package to Catalogue ========\n\n\n"
#resp=$(curl -qSfsw '\n%{http_code}' -H 'content-disposition: attachment; filename=sonata_example.son' \
#  -H 'content-type: application/zip' \
#  -F "package=@resources/sonata-demo.son" -X POST http://sp.int3.sonata-nfv.eu:4002/catalogues/son-packages)
#echo $resp

#package=$(echo $resp | grep "uuid")
#echo "UUID: $package"

#code=$(echo "$resp" | tail -n1)
#echo "Code: $code"

printf "\n\n======== GET Package UUID from Gatekeeper  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X GET http://sp.int3.sonata-nfv.eu:32001/api/v2/packages) 2>/dev/null
echo $resp

package=$(echo "$resp" | head -n-1)
uuid=$(echo $package  |  python -mjson.tool | grep "uuid" | awk -F'[=:]' '{print $2}' | sed 's/\"//g' | tr -d ',' | tr -d '[:space:]')
echo "UUID: $uuid"

printf "\n\n======== GET SON Package from Gatekeeper ========\n\n\n"
#url=$(echo http://sp.int3.sonata-nfv.eu:32001/packages/${uuid})
#echo "URL: $url"
resp=$(curl -qSfsw '\n%{http_code}' -X GET http://sp.int3.sonata-nfv.eu:32001/api/v2/packages/${uuid}) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== GET SON Package UUID from Catalogue  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X GET http://sp.int3.sonata-nfv.eu:4002/catalogues/son-packages) 2>/dev/null
echo $resp

package=$(echo "$resp" | head -n-1)
uuid=$(echo $package  |  python -mjson.tool | grep "uuid" | awk -F'[=:]' '{print $2}' | sed 's/\"//g' | tr -d ',' | tr -d '[:space:]')
echo "UUID: $uuid"

#printf "\n\n======== GET SON Package from Catalogue ========\n\n\n"
#url=$(echo http://sp.int3.sonata-nfv.eu:32001/packages/${uuid})
#url=$(echo http://sp.int3.sonata-nfv.eu:4002/catalogues/son-packages/${uuid})
#echo "URL: $url"
#resp=$(curl -qSfsw '\n%{http_code}' -X GET http://sp.int3.sonata-nfv.eu:32001/packages/${uuid}) 2>/dev/null
#resp=$(curl -qSfsw '\n%{http_code}' -X GET http://sp.int3.sonata-nfv.eu:4002/catalogues/son-packages/${uuid}) 2>/dev/null
#echo $resp

#code=$(echo "$resp" | tail -n1)
#echo "Code: $code"

#if [[ $code != 200 ]] ;
#  then
#    echo "Error: Response error $code"
#    exit -1
#fi

