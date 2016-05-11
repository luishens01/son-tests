#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: `basename "$0"` <son-catalogue server> <son-catalogue PORT>"
	exit 1
fi 

#set -e

# install resty REST client
curl -L http://github.com/micha/resty/raw/master/resty > resty
. resty

resty http://$1:$2


# delete components from son-catalogue server
{
DELETE /network-services/id/eu.sonata-nfv.service-descriptor.sonata-demo.0.2
DELETE /network-services/id/eu.sonata-nfv.service-descriptor.sample-nsd.0.2
DELETE /vnfs/id/eu.sonata-nfv.tcpdump-vnf.0.1
DELETE /vnfs/id/eu.sonata-nfv.firewall-vnf.0.1
DELETE /vnfs/id/eu.sonata-nfv.iperf-vnf.0.1
DELETE /vnfs/id/eu.sonata-nfv.vnf-sample.0.1
} > /dev/null 2>&1

# cleanup
rm resty

