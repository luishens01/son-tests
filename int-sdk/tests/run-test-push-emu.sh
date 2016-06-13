#!/bin/bash

set -xe

#cleanup
printf "\n\n======== Cleaning dir structure ========\n\n\n"
scripts/cleanup.sh

# clean catalogues
printf "\n\n======== Cleaning SDK Catalogue ========\n\n\n"
scripts/clean-catalogue-server.sh 127.0.0.1 4012

# Prepare working environment
export COLOREDLOGS_LOG_FORMAT='%(asctime)s %(name)s[%(process)d] %(levelname)s %(message)s'
mkdir -p workspaces projects packages

# son-emu
printf "\n\n======== Testing: Workspace + Project + Dep-Project, push to SON-EMU ========\n\n\n"
scripts/1_create_son_workspace.sh workspaces/ws1
scripts/2_create_standalone-project.sh workspaces/ws1 projects/prj1 http://127.0.0.1:5000 resources/project-Y1-emu.zip
scripts/3_create_dependent-project.sh workspaces/ws1 projects/prj2 http://127.0.0.1:5000 resources/project-Y1-emu.zip
