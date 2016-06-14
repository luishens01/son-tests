#!/bin/bash
printf "\n\n======== POST Package to Gatekeeper ========\n\n\n"
resp=$(curl -qSfsw '\n%{http_code}' -F "package=@int-gtkpkg-sp-catalogue/resources/sonata-demo.son" -X POST http://sp.int3.sonata-nfv.eu:32001/packages)
echo $resp

package=$(echo $resp | grep "uuid")

code=$(echo "$resp" | tail -n1)
echo "Code: $code"

if [[ $code != 201 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi


