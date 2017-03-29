#!/bin/bash
set -e
set -x

printheader "https://github.com/sonata-nfv/son-emu/wiki/Example-2"

SONEMU() {
    docker exec son-emu-int-sdk-pipeline "$@"
}

SONCLI() {
    docker exec son-cli-int-test "$@"
}

SONEMU sed -i 's/enable_learning=False/enable_learning=True/' /son-emu/src/emuvim/examples/sonata_y1_demo_topology_1.py

### Starting the topology
SONEMU screen -L -S sonemu -d -m sudo python /son-emu/src/emuvim/examples/sonata_y1_demo_topology_1.py
### Setup screen for immediate flusing
SONEMU screen -S sonemu -X logfile flush 0
### Wait for the cli to start
SONEMU W '^*** Starting CLI:' 60s
### Print nodes
SONEMU Cmd 'nodes'

SONCLI son-access -p emu push --upload son-examples/service-projects/sonata-empty-service.son
SONCLI son-access -p emu push --deploy latest

SONEMU son-emu-cli compute list
SONEMU sync # avoid text overlapping

SONEMU Cmd 'empty_vnf2 ifconfig && echo "... checked empty_vnf2"'
SONEMU W "^... checked empty_vnf2"
SONEMU Cmd 'empty_vnf1 ping -v -c 2 empty_vnf2 && echo "... checked ping between empty_vnf1 and empty_vnf2"'
SONEMU W "^... checked ping between empty_vnf1 and empty_vnf2"
SONEMU Cmd 'empty_vnf2 ping -v -c 2 empty_vnf1 && echo "... checked ping between empty_vnf2 and empty_vnf1"'
SONEMU W "^... checked ping between empty_vnf2 and empty_vnf1"

SONEMU Cmd 'quit'
W "^*** Done"

printheader "(Result) https://github.com/sonata-nfv/son-emu/wiki/Example-2"
SONEMU strings screenlog.0
