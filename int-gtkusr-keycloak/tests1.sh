#!/bin/bash
printf "\n\n======== POST User Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -F "package=@int-gtkusr-keycloak/resources/xxxxxxx.son" -X POST http://http://sp.int3.sonata-nfv.eu:5600/api/v2/register/user)
echo $resp

username=$(echo $resp | grep "username")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi