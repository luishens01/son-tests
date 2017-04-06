#!/bin/bash
# Contact UM_Adapter-DB <--- Not implemented yet
#status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:27017/)

#if [[ $status_code != 20* ]] ;
#  then
#    echo "Error: Response error $status_code"
#    exit -1
#fi
#echo "Success: UM_Adapter-DB found"

# Contact Gatekeeper - son-gtkusr
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:5600/admin)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: User Management found"

# Contact Gatekeeper - Keycloak
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:5601/)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: Keycloak found"
echo "Waiting for configuration load..."
sleep 50s
