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
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:32001/)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: Gatekeeper found"