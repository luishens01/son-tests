#!/bin/bash

# Report directory
REP_DIR=$(pwd)/reports
read -r REQ_ID
read -r SERV_ID

echo "<HTML>
<HEAD>
    <style>
		body {
            font-family: "open_sans", sans-serif
        }
		.suite header {
            margin: 0;
            padding: 5px 0 5px 5px;
            background: #003d57;
            color: white
        }
        table {
            border-collapse: collapse;
        }
        table,
        td,
        th {
            border: 1px solid black;
        }
    </style>
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
</HEAD>
<BODY>" > $REP_DIR/intermediate_Info.html

# View hostname and insert it at the top of the html body
HOST=$(hostname)
echo "Filesystem usage for host <strong>$HOST</strong><br>
Last updated: <strong>$(date)</strong><br><br>
<table border='1'>
<tr>
<th class='header'>Step</td>
<th class='header'>Module</td>
<th class='header'>Description</td>
<th class='header'>Info</td>
<th class='header'>Step Status</td>
</tr>" >> $REP_DIR/intermediate_Info.html

# check 1 - gtkapi: POST received
echo "<tr><td align='center'>01</td><td align='center'>son-gtkapi</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>POST /requests received</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from graylog son-gtkapi messages that include "POST"
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword/export?query=container_name%3Ason-gtkapi%20AND%20message%3A*POST*&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
# info: uppercase(logmessage) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *POST[[:space:]]\/REQUESTS* ]] ;
then
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 2
echo "<tr><td align='center'>02</td><td align='center'>son-gtksrv</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>POST /requests received</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from graylog son-gtksrv messages that include "POST"
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword/export?query=container_name%3Ason-gtksrv%20AND%20message%3A*POST*&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
# info: uppercase(logmessage) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *POST[[:space:]]\/REQUESTS* ]] ;
then
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 3 - gtksrv: request created
# info: get from gatekeeper all requests
LOGMESSAGE=$(curl -X GET "http://sp.int3.sonata-nfv.eu:32001/requests")
# info: uppercase(logmessage) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
# info: get last occurrence of "ID: \""
LOGMESSAGE=$(echo $LOGMESSAGE| awk -F"\"ID\":\"" '{print $NF}')
# info: get REQUEST ID
REQUESTID=${LOGMESSAGE:0:36}

echo "<tr><td align='center'>03</td><td align='center'>son-gtksrv</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>Request created</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from graylog son-gtksrv messages that include "INSERT INTO \"requests\""
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword/export?query=container_name%3Ason-gtksrv%20AND%20message%3A*INSERT+INTO+"requests"*&keyword=last%205%20minutes&fields=container_name%2Cmessage")
# info: lowercase(uppercase(requestid))
LOWERCASEREQUESTID=$(echo $REQUESTID | tr '[:upper:]' '[:lower:]')
echo $LOGMESSAGE "Request Id: " $LOWERCASEREQUESTID >> $REP_DIR/intermediate_Info.html
# info: uppercase(LOGMESSAGE) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *INSERT[[:space:]]INTO[[:space:]]\"\"REQUESTS* ]] ;
then
	STRTOFIND="\[\"\"SERVICE_UUID\"\", \"\"" 
	# info: get position of SERVICE_UUID
	STRINDEX=$(echo $LOGMESSAGE | grep -aob '\[\"\"SERVICE_UUID\"\", \"\"' | grep -oE '[0-9]+')
	STRINDEX=$(($STRINDEX + ${#STRTOFIND} -1))
	SERVICEID=${LOGMESSAGE:STRINDEX:36}
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html		
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 4 - servicelifecyclemanagement: service.instances.create received
echo "<tr><td align='center'>04</td><td align='center'>servicelifecyclemanagement</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>Instance creation request received</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from graylog servicelifecyclemanagement messages that include "received on service.instances.create"
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword/export?query=container_name%3Aservicelifecyclemanagement%20AND%20message%3A*received+on+service.instances.create*&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
# info: uppercase(LOGMESSAGE) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *RECEIVED[[:space:]]ON[[:space:]]SERVICE.INSTANCES.CREATE[[:space:]]CORR_ID:[[:space:]]$REQUESTID* ]] ;
then		
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html		
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 5 - son-sp-infrabstract: Received message on infrastructure.service.deploy
echo "<tr><td align='center'>05</td><td align='center'>son-sp-infrabstract</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>Received message on infrastructure.service.deploy</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from graylog son-sp-infrabstract messages that include "Received message on infrastructure.service.deploy"
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword?query=container_name%3Ason-sp-infrabstract%20AND%20message%3AReceived%20message%20on%20infrastructure.service.deploy&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
# info: uppercase(LOGMESSAGE) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *RECEIVED[[:space:]]MESSAGE[[:space:]]ON[[:space:]]INFRASTRUCTURE.SERVICE.DEPLOY* ]] ;
then		
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html		
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 6 - servicelifecyclemanagement: Deployment reply received from IA
echo "<tr><td align='center'>06</td><td align='center'>servicelifecyclemanagement</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>Deployment reply received from IA</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get graylog servicelifecyclemanagement messages that include "Deployment reply received from IA"
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword?query=container_name%3Aservicelifecyclemanagement%20AND%20message%3ADeployment%20reply%20received%20from%20IA&keyword=last%205%20minutes&fields=container_name%2Cmessage")

echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
# info: uppercase(LOGMESSAGE) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *DEPLOYMENT[[:space:]]REPLY[[:space:]]RECEIVED[[:space:]]FROM[[:space:]]IA[[:space:]]FOR[[:space:]]INSTANCE[[:space:]]UUID[[:space:]]$REQUESTID* ]] ;
then		
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html		
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 7 - servicelifecyclemanagement: inform gk of result of deployment
echo "<tr><td align='center'>07</td><td align='center'>servicelifecyclemanagement</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>Inform gk of result of deployment</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from graylog servicelifecyclemanagement messages that include "inform gk of result of deployment"
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@http://10.31.11.37:12900/search/universal/keyword?query=container_name%3Aservicelifecyclemanagement%20AND%20message%3Ainform%20gk%20of%20result%20of%20deployment&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
# info: uppercase(LOGMESSAGE) and delete duplicated spaces
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $LOGMESSAGE  ==  *INFORM[[:space:]]GK[[:space:]]OF[[:space:]]RESULT[[:space:]]OF[[:space:]]DEPLOYMENT[[:space:]]FOR[[:space:]]SERVICE[[:space:]]WITH[[:space:]]UUID* ]] ;
then
	# info: get service instance id
	STRTOFIND="WITH UUID " 
	STRINDEX=$(echo $LOGMESSAGE | grep -aob 'WITH UUID ' | grep -oE '[0-9]+')
	STRINDEX=$(($STRINDEX + ${#STRTOFIND}))
	SERVICEINSTANCEID=${LOGMESSAGE:STRINDEX:36}
	LOWERCASESERVICEINSTANCEID=$(echo $SERVICEINSTANCEID | tr '[:upper:]' '[:lower:]')	
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html		
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 8 - son-catalogue-repos: retrieve instances
echo "<tr><td align='center'>08</td><td align='center'>son-catalogue-repos</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>Retrieve Service Instance from SP Repository</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
# info: get from SP repository the instance
LOGMESSAGE=$(curl -X GET -H "Content-Type:application/json" "http://sp.int3.sonata-nfv.eu:4002/records/nsr/ns-instances/$LOWERCASESERVICEINSTANCEID")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
LOGMESSAGE=$(echo "${LOGMESSAGE^^}" | tr -s " ")
if [[ $SERVICEINSTANCEID != "" && $LOGMESSAGE  ==  *$SERVICEINSTANCEID* ]] ;
then		
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html		
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

echo "</table></BODY></HTML>" >> $REP_DIR/intermediate_Info.html