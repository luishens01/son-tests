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
