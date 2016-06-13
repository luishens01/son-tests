#!/bin/bash

set -xe

#cleanup
printf "\n\n======== Cleaning dir structure ========\n\n\n"
scripts/cleanup.sh

printf "\n\n======== Cleaning SDK Catalogue ========\n\n\n"
scripts/clean-catalogue-server.sh 127.0.0.1 4012

# Prepare working environment
export COLOREDLOGS_LOG_FORMAT='%(asctime)s %(name)s[%(process)d] %(levelname)s %(message)s'
mkdir -p workspaces projects packages

#### test son-cli tools ####
scripts/1_create_son_workspace.sh workspaces/ws_test
son-workspace --workspace workspaces/ws_test --project projects/prj_test
son-publish --workspace workspaces/ws_test --project projects/prj_test
son-package --workspace workspaces/ws_test --project projects/prj_test -d packages/package_test -n project-test
