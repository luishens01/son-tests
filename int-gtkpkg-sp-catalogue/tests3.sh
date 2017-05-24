#!/bin/bash
#
printf "\n\n======== GET Function from Gatekeeper  ========\n\n\n"
### Login phase
echo "Authenticating to the Service Platform..."

resp=$(curl -qSfsw '\n%{http_code}' -d '{"username":"jenkins","password":"1234"}' \
http://sp.int3.sonata-nfv.eu:32001/api/v2/sessions)
echo $resp

token=$(echo $resp | awk '{json=$1 FS $2 FS $3; print json}' | python -mjson.tool | grep "access_token" | awk -F ':[ \t]*' '{print $2}' | sed 's/,//g' | sed 's/"//g')
echo "TOKEN="$token

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -H "Authorization: Bearer $token" \
-X GET http://sp.int3.sonata-nfv.eu:32001/api/v2/functions?fields=uuid,name,version,vendor) 2>/dev/null
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

set -- $uuid
# echo $1
# echo $2
# echo $3

resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -H "Authorization: Bearer $token" \
-X GET http://sp.int3.sonata-nfv.eu:32001/api/v2/functions/$1) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

### Logout phase
echo "Log-out of the Service Platform..."
resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Bearer $token" \
-X DELETE http://sp.int3.sonata-nfv.eu:32001/api/v2/sessions) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 20* ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi
