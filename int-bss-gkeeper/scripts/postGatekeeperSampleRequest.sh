#!/bin/bash
set -x
set -e
# -- insert request
printf "\n\n======== Insert request  ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -X POST http://sp.int3.sonata-nfv.eu:32001/requests?service_uuid=8b47d222-560a-4cad-a54a-793b1ee8849e)
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
