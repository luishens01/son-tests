#!/bin/bash

status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:8000/api/v1/users)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1 
fi

resp=$(curl -s http://sp.int3.sonata-nfv.eu:8000/api/v1/users)
admin=$(echo $resp | python -mjson.tool | grep '"sonata_userid": "admin"' | xargs)
sp_admin=$(echo $resp | python -mjson.tool | grep '"sonata_userid": "sp_admin"' | xargs)
system=$(echo $resp | python -mjson.tool | grep '"sonata_userid": "system"' | xargs)

if [ -z "$admin" ];
 then
   echo "Error: Admin user not found" 
   exit -1
fi

if [ -z "$sp_admin" ];
 then
   echo "Error: SP Admin user not found" 
   exit -1
fi

if [ -z "$system" ];
 then
   echo "Error: Systm user not found" 
   exit -1
fi

echo "Success: System users are set {$admin, $sp_admin, $system}"