#!/bin/bash
#
# This script creates  SONATA project with external dependencies based on the demo 
# for year 1.
# It receives two arguments, the workspace location and the path where the project
# should be created
#

# Check arguments

if [[ $# < 2 ]] || [[ $# > 4 ]]; then
        echo "Usage: `basename "$0"` <workspace_location> <project_location> <gatekeeper_url> [<project template>]"
        exit 1
fi
 
if [[ $# == 3 ]]; then
        new_project=true
elif [[ $# == 4 ]]; then
        new_project=false
        project_template=$4
fi

printf "\n\n==> Create *dependent* project '%s' [son-workspace --project]\n\n" "$2"

# Define global parameters
set -xe
timestamp="$(date +%s).$(date +%N)"
package_dir="packages/package.$timestamp"
gatekeeper_url=$3

# Create project

if [[ "$new_project" = true ]]; then
        son-workspace --workspace $1 --project $2
else 
        # Create predefined project. Make project incomplete, remove some VNFs
        unzip -o $project_template
        mv project-Y1 $2
        printf "\n\n==> Remove some project components to make it incomplete\n\n" "$2"
	    rm $2/sources/vnf/firewall/firewall-vnfd.yml
	    rm -d $2/sources/vnf/firewall
	    rm $2/sources/vnf/iperf/iperf-vnfd.yml
	    rm -d $2/sources/vnf/iperf
fi

# Package project
#printf "\n\n==> Package project '%s' [son-package --project]\n\n" "$2"
#son-package --workspace $1 --project $2 -d $package_dir

# Push packaged project to Gatekeeper
#printf "\n\n==> Push packaged project to GateKeeper [son-push]\n\n"
#PACKAGE_FILE=$(find $package_dir/*.son -type f -printf "%f")
#son-push -U $package_dir/$PACKAGE_FILE $gatekeeper_url
