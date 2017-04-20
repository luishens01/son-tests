#!/bin/bash
set -e
set -x

printheader "Preparing workspace"
cd /tmp/workspace
git clone https://github.com/sonata-nfv/son-examples.git
cd son-examples/vnfs
printheader "Creating empty vnf"
docker build -t sonatanfv/sonata-empty-vnf -f sonata-empty-vnf-docker/Dockerfile sonata-empty-vnf-docker
printheader "Packaging the empty service"
docker exec son-cli-int-test bash -c 'cd son-examples/service-projects && son-package --project sonata-empty-service-emu -n sonata-empty-service'

printheader "(Info) List of images"
docker exec son-cli-int-test docker images
