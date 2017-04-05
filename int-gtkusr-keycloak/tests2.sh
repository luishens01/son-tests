#!/bin/bash
printf "\n\n======== POST User (Developer) Login to GTKUSR ==\n\n\n"
creds=$(echo -n 'user01:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/user)
echo $resp

#token=$(echo $resp | grep "access_token")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== POST User (Customer) Login to GTKUSR ==\n\n\n"
creds=$(echo -n 'user02:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/user)
echo $resp

#token=$(echo $resp | grep "access_token")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== POST Service (Micro-service) Login to GTKUSR ==\n\n\n"
creds=$(echo -n 'son-catalogue:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/user)
echo $resp

#token=$(echo $resp | grep "access_token")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi