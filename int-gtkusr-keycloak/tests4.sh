#!/bin/bash
printf "\n\n======== POST User (Developer) Logout to GTKUSR ==\n\n\n"
creds=$(echo -n 'user01:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/user)
echo $resp

token=$(echo $resp | awk '{print $1}' | python -mjson.tool | grep "access_token" | awk -F ':[ \t]*' '{print $2}' | sed 's/,//g' | sed 's/"//g')

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Bearer $token" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/logout) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 20* ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== POST User (Customer) Logout to GTKUSR ==\n\n\n"
creds=$(echo -n 'user02:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/user)
echo $resp

token=$(echo $resp | awk '{print $1}' | python -mjson.tool | grep "access_token" | awk -F ':[ \t]*' '{print $2}' | sed 's/,//g' | sed 's/"//g')

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Bearer $token" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/logout) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 20* ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== POST Service (Micro-service) Logout to GTKUSR ==\n\n\n"
creds=$(echo -n 'son-catalogue:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/service)
echo $resp

token=$(echo $resp | awk '{print $1}' | python -mjson.tool | grep "access_token" | awk -F ':[ \t]*' '{print $2}' | sed 's/,//g' | sed 's/"//g')

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Bearer $token" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/logout) 2>/dev/null
echo $resp

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 20* ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi