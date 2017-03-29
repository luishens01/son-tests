#!/bin/bash
# Contact UM_Adapter-DB <--- Not implemented yet
#status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:27016/)

#if [[ $status_code != 20* ]] ;
#  then
#    echo "Error: Response error $status_code"
#    exit -1
#fi
#echo "Success: UM_Adapter-DB found"

# Contact Gatekeeper - gtkusr
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:5600/)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: User Management found"

# Contact Gatekeeper - Keycloak <---- To be defined
#status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:5601/)

#if [[ $status_code != 20* ]] ;
#  then
#    echo "Error: Response error $status_code"
#    exit -1
#fi
#echo "Success: Keycloak found"
