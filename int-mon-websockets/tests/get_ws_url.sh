#!/bin/bash

#Get WS url
resp=$(curl -s -X POST http://sp.int3.sonata-nfv.eu:8000/api/v1/ws/new -d @int-mon-websockets/resources/new_ws_req.json -H "Accept: application/json" -H "Content-Type: application/json")

status=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["status"]')

if [[ "$status" = "SUCCESS" ]]; then
	ws=$(echo $resp | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["ws_url"]')
	echo $ws
	echo "Success: WS created ($ws)"
	exit
fi

echo "Error: On WS Creation" 
exit -1
