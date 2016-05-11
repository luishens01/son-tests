#!/bin/bash
#
# This script creates  SONATA project with external dependencies based on the demo 
# for year 1.
# It receives two arguments, the workspace location and the path where the project
# should be created
#

# Check arguments

if [[ $# < 2 ]] || [[ $# > 3 ]]; then
        echo "Usage: `basename "$0"` <workspace_location> <project_location> [<project template>]"
        exit 1
fi
 
if [[ $# == 2 ]]; then
        new_project=true
elif [[ $# == 3 ]]; then
        new_project=false
        project_template=$3
fi


# Define global parameters
set -xe
timestamp="$(date +%s).$(date +%N)"
package_dir="packages/package.$timestamp"


# Create project

if [[ "$new_project" = true ]]; then
        son-workspace --workspace $1 --project $2
else 
        # Create predefined project. Make project incomplete, remove some VNFs
        unzip -o $project_template
        mv project-Y1 $2
	rm $2/sources/vnf/firewall/firewall-vnfd.yml
	rm -d $2/sources/vnf/firewall/firewall
	rm $2/sources/vnf/iperf/iperf-vnfd.yml
	rm -d $2/sources/vnf/iperf
fi

# Package project
son-package --workspace $1 --project $2 -d $package_dir -n project-Y1

# Push packaged project to Gatekeeper #### DISABLE PUSH, FOR NOW
#son-push http://127.0.0.1:5000 -U $package_dir/project-Y1.son

