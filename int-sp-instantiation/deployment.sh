#!/bin/bash
#DEPLOYMENT (ensure that we have the latest conainers available)
export DOCKER_HOST="tcp://192.168.60.25:2375"
# MANO FRAMEWORK
docker pull registry.sonata-nfv.eu:5000/sonmanobase
docker pull registry.sonata-nfv.eu:5000/pluginmanager
docker pull registry.sonata-nfv.eu:5000/exampleplugin
docker pull registry.sonata-nfv.eu:5000/servicelifecyclemanagement
docker pull registry.sonata-nfv.eu:5000/functionlifecyclemanagement
docker pull registry.sonata-nfv.eu:5000/placementexecutive
# INFRSTRUCTURE ADAPTOR
docker pull registry.sonata-nfv.eu:5000/son-sp-infrabstract
# GATEKEEPER
docker pull registry.sonata-nfv.eu:5000/son-gtkapi
docker pull registry.sonata-nfv.eu:5000/son-gtkpkg
docker pull registry.sonata-nfv.eu:5000/son-gtksrv
export DOCKER_HOST="unix:///var/run/docker.sock"
