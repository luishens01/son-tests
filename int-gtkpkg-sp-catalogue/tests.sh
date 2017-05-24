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
{"username": "demo",
 "enabled": true,
 "totp": false,
 "emailVerified": false,
 "firstName": "Demo",
 "lastName": "User",
 "email": "demo.user@email.com",
 "credentials": [{"type": "password","value": "demo"}],
 "requiredActions": [],
 "federatedIdentities": [],
 "attributes": {"userType": ["developer","customer"]},
 "realmRoles": [],
 "clientRoles": {},
 "groups": []}
EOF
}

# echo "$(demo_reg_data)"
printf "\n\n======== POST Demo User (predefined) Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
-d "$(demo_reg_data)" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/register/user)
echo $resp

username=$(echo $resp | grep "username")
code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Response $code"
fi
