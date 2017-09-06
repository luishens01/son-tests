#!/bin/bash

echo "\n\n======= Performing SDK son-access Integration tests =======\n\n"

# Contact Gatekeeper
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://sp.int3.sonata-nfv.eu:32001/api)

if [[ $status_code != 20* ]] ;
  then
    echo "Error: Response error $status_code"
    exit -1
fi
echo "Success: Gatekeeper found"

# work with integration master
#git checkout integration/master

# needed to extract project templates
#sudo apt-get install unzip

# execute the tests
#cd int-sdk/tests

#set -xe
#./clean-environment.sh

# Test 1
echo "Running test 1"
son-workspace --init --workspace workspaces/ws1 --debug
# unzip -o resources/project-Y1-sp.zip && mv project-Y1 projects/prj1
son-access --workspace workspaces/ws1 config --new --platform_id "sp_int3" --url http://sp.int3.sonata-nfv.eu:32001 -u demo -p demo --default
sleep 2
son-access --workspace workspaces/ws1 auth
sleep 2
son-access --workspace workspaces/ws1 list services
sleep 1
son-access --workspace workspaces/ws1 list functions
sleep 1
son-access --workspace workspaces/ws1 list packages
sleep 1
son-access --workspace workspaces/ws1 push --upload src/son/access/samples/sonata-demo.son
sleep 1
son-access --workspace workspaces/ws1 push --upload src/son/access/samples/sonata-demo.son --sign
sleep 1
son-access --workspace workspaces/ws1 auth --logout
sleep 1


