#!/bin/bash

set -xe

#cleanup
#./cleanup.sh
./scripts/clean-catalogue-server.sh 127.0.0.1 4011

# Prepare working environment
mkdir -p workspaces projects packages


# son-emu
scripts/1_create_son_workspace.sh workspaces/ws1
scripts/2_standalone-project-y1.sh workspaces/ws1 projects/prj1 resources/project-Y1-emu.zip
#scripts/3_dependent-project-y1.sh ws1 prj2 resources/project-Y1-emu.zip

# clean catalogues
scripts/clean-catalogue-server.sh 127.0.0.1 4011


# son-sp
#scripts/1_create_son_workspace.sh ws2
#scripts/2_standalone-project-y1.sh ws2 prj3 resources/project-Y1-sp.zip
#scripts/3_dependent-project-y1.sh ws2 prj4 resources/project-Y1-sp.zip


