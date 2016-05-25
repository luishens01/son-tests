#!/bin/bash
#
# Perform multiple integration tests.
# - Creation of workspaces, projects
# - Publication of components to son-catalogue server
# - Packaging of projects
# - Push to son-emu and to SP
#

echo "\n\n======= Performing SDK Integration Tests =======\n\n"

# work in integration master
git checkout integration/master

# execute the tests
cd int-sdk
./run-tests.sh
