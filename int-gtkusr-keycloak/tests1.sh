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

printf "\n\n======== POST User (Developer) Duplicated Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" \
-d "@int-gtkusr-keycloak/resources/user_d_registration.json" \
-X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/register/user)
echo $resp

username=$(echo $resp | grep "username")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 40* ]] ;
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

printf "\n\n======== Login as Platform Admin to GTKUSR ==\n\n\n"
creds=$(echo -n 'sonata:1234' | base64)
echo "Credentials: $creds"

resp=$(curl -qSfsw '\n%{http_code}' -H "Authorization: Basic $creds" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d '' -X POST http://sp.int3.sonata-nfv.eu:5600/api/v1/login/user)
echo $resp

token=$(echo $resp | awk '{print $1}' | python -mjson.tool | grep "access_token" | awk -F ':[ \t]*' '{print $2}' | sed 's/,//g' | sed 's/"//g')
echo $token

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi

printf "\n\n======== POST User (Admin) Registration form to GTKUSR ==\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -H "Content-Type: application/json" -H "Authorization: Bearer $token" \
-d "@int-gtkusr-keycloak/resources/user_a_registration.json" \
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