#!/bin/bash

#Create and retrieve data from a WS
resp=$(python int-mon-websockets/tests/ws_client.py)

#Return status
if [ $resp = "True" ] 
 then
   echo "Success: Monitoring data from WS arrived"
 else
   echo "Error: Process failed"
   exit -1
fi

