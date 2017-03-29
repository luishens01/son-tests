#! /bin/bash
set -e
set -x

printheader "https://github.com/sonata-nfv/son-emu/wiki/Example-1"

SONEMU() {
    docker exec son-emu-int-sdk-pipeline "$@"
}

SONCLI() {
    docker exec son-cli-int-test "$@"
}

### Starting the topology
SONEMU screen -L -S sonemu -d -m sudo python /son-emu/src/emuvim/examples/sonata_y1_demo_topology_1.py
### Setup screen for immediate flusing
SONEMU screen -S sonemu -X logfile flush 0
### Wait for the cli to start
SONEMU W '^*** Starting CLI:' 60s


SONEMU son-emu-cli compute start -d dc1 -n client -i sonatanfv/sonata-empty-vnf
SONEMU son-emu-cli compute start -d dc2 -n server -i sonatanfv/sonata-empty-vnf
SONEMU son-emu-cli network add -b -src client:client-eth0 -dst server:server-eth0

SONEMU Cmd 'client ping -v -c 2 server && echo "... checked ping"'
SONEMU W "^... checked ping"


SONEMU Cmd 'quit'
SONEMU W "^*** Done"

printheader "(Result) OK for https://github.com/sonata-nfv/son-emu/wiki/Example-1"
SONEMU strings screenlog.0
