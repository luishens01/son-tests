#!/bin/bash

# Report directory
REP_DIR=$(pwd)/reports
FILENAME=$REP_DIR/ids.txt
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
<th class='header'>Info</td>
<th class='header'>Test Status</td>
</tr>" >> $REP_DIR/intermediate_Info.html

# check 1 - gtkapi: POST received
echo "<tr><td align='center'>" >> $REP_DIR/intermediate_Info.html
echo "POST received by gtkapi" >> $REP_DIR/intermediate_Info.html
echo "</td><td align='center'>" >> $REP_DIR/intermediate_Info.html
curl -X GET http://10.31.11.37:12900/search/universal/keyword?query=source%3Aint-server-3%20AND%20message%3A%22POST%20AND%20message%3A%22$REQ_ID%22&keyword=last%20hour&fields=container_name%2Cmessage >> LOGMESSAGE
echo $LOGMESSAGE >> $REP_DIR/intermediate_Info.html
if [ conditional expression ]
then
	echo "</td><td align='center' bgcolor=lightgreen>" >> $REP_DIR/intermediate_Info.html
	echo "PASSED" >> $REP_DIR/intermediate_Info.html
else
	echo "</td><td align='center' bgcolor=red>" >> $REP_DIR/intermediate_Info.html
	echo "FAILED" >> $REP_DIR/intermediate_Info.html
fi

# check 2
echo "</table></BODY></HTML>" >> $REP_DIR/intermediate_Info.html