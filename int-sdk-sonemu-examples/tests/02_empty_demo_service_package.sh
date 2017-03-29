#!/bin/bash
set -e
set -x

printheader "https://github.com/sonata-nfv/son-emu/wiki/Example-2"

SONEMU() {
    docker exec son-emu-int-sdk-pipeline "$@"
}

### Starting the topology
docker exec son-emu-int-sdk-pipeline screen -L -S sonemu -d -m sudo python src/emuvim/examples/sonata_y1_demo_topology_1.py
### Setup screen for immediate flusing
docker exec son-emu-int-sdk-pipeline screen -S sonemu -X logfile flush 0
### Wait for the cli to start
docker exec son-emu-int-sdk-pipeline W '^*** Starting CLI:' 60s
### Print nodes
SONEMU Cmd 'nodes'

printheader "Containernet traces"
SONEMU strings screenlog.0
