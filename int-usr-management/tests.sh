#!/bin/bash

UM_URL=http://sp.int3.sonata-nfv.eu:5600/api/v1/refresh

echo
echo "------------------------------------------------------------------------"
echo "*** Verifying if Gatekeeper User Management is up and ready on $UM_URL"
retries=0
until [ $(curl --connect-timeout 15 --max-time 15 -k -s -o /dev/null -I -w "%{http_code}" $UM_URL) -eq 200 ]; do
    	#printf '.'
    	sleep 10
    	let retries="$retries+1"
    	if [ $retries -eq 10 ]; then
		echo "Timeout waiting for User Management module on $UM_URL"
		exit -1
	fi
done

echo "Gatekeeper User Management up and ready!"

cd int-usr-management/bss_resources
./node_modules/grunt/bin/grunt test --host=sp.int3.sonata-nfv.eu --port=25001 --protocol=https --suite=bssUserManagement
