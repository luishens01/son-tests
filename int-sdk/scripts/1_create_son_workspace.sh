#!/bin/bash
#
# This script creates a SONATA workspace and configures it with the appropriate
# catalogue servers and schema repositories, for integration tests
# It receives one argument to declare  where the workspace should be created
#

if [[ $# != 1 ]]; then
	echo "Usage: `basename "$0"` <workspace_location>"
	exit 1
fi 

# Define global parameters
set -xe
export cat_server1="http://127.0.0.1:4011"


# Create workspace
son-workspace --init --debug --workspace $1

# Configure workspace
sed -ri '/^.*catalogue_servers:|id:|publish:|url:.*$/d' $1/workspace.yml
echo -e "catalogue_servers:\n- id: cat1\n  publish: 'yes'\n  url: $cat_server1" >> $1/workspace.yml

