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
<tr><th class='header'>Module</td>
<th class='header'>Description</td>
<th class='header'>Info</td>
<th class='header'>Test Status</td>
</tr>" >> $REP_DIR/intermediate_Info.html

# check 1 - gtkapi: POST received
echo "<tr><td align='center'>son-gtkapi</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>POST /requests received</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword/export?query=container_name%3Ason-gtkapi%20AND%20message%3A*POST*&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html

if [[ $LOGMESSAGE  ==  *POST[[:space:]]\/requests* ]] ;
then
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 2
echo "<tr><td align='center'>son-gtksrv</td>" >> $REP_DIR/intermediate_Info.html
echo "<td align='center'>POST /requests received</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
LOGMESSAGE=$(curl -X GET "http://admin:s0n%40t%40@10.31.11.37:12900/search/universal/keyword/export?query=container_name%3Ason-gtksrv%20AND%20message%3A*POST*&keyword=last%205%20minutes&fields=container_name%2Cmessage")
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html

if [[ $LOGMESSAGE  ==  *POST[[:space:]]\/requests* ]] ;
then
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

echo "</table></BODY></HTML>" >> $REP_DIR/intermediate_Info.html