#!/bin/bash
printf "\n\n======== POST User (Developer) Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
-d "@int-gtkusr-keycloak/resources/user_d_registration.json" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/register/user)
echo $resp

username=$(echo $resp | grep "username")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== POST User (Customer) Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
-d "@int-gtkusr-keycloak/resources/user_c_registration.json" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/register/user)
echo $resp

username=$(echo $resp | grep "username")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

# printf "\n\n======== POST User (Developer+Customer) Registration form to GTKUSR ==\n\n\n"
# resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
# -d "@int-gtkusr-keycloak/resources/user_dc_registration.json" \
# -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/register/user)
# echo $resp

# username=$(echo $resp | grep "clientId")

# code=$(echo "$resp" | tail -n1)
# echo "Code: $code"

# if [[ $code != 201 ]] ;
#   then
#     echo "Error: Response error $code"
#     exit -1
# fi

printf "\n\n======== POST Service (Micro-service) Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
-d "@int-gtkusr-keycloak/resources/service_registration.json" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/register/service)
echo $resp

username=$(echo $resp | grep "clientId")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi