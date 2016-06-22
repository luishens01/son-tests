#!/bin/bash

# -- insert VNFR

curl -H "Content-Type: application/json" -X POST -d @int-slm-repositories/resources/vnfr.json http://api.int.sonata-nfv.eu:4002/records/vnfr/vnf-instances
