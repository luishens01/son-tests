#!/bin/bash
# Contact Catalogues-DB
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:27017/)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: Catalogues-DB found"

# Contact Gatekeeper
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:32001/api)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: Gatekeeper found"

# Integration user checks
demo_reg_data() {
    cat << EOF
{"username":"jenkins","password":"1234","user_type":"developer","email":"jenkins.user@email.com"}
EOF
}

# echo "$(demo_reg_data)"
printf "\n\n======== POST Jenkins User (integration test user) Registration form to Gatekeeper ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
-d "$(demo_reg_data)" \
-X POST http://sp.int3.sonata-nfv.eu:32001/api/v2/users)
echo $resp

username=$(echo $resp | grep "username")
code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Response $code"
fi
