#!/bin/bash
set -e
set -x

SONEMU() {
    docker exec son-emu-int-sdk-pipeline "$@"
}

printheader "Cleaning son-emu"
SONEMU pkill -f 'SCREEN -L -S sonemu' || true
SONEMU screen -wipe || true
SONEMU rm -f screenlog.0

SONEMU ps
