#!/bin/bash

# -- POST NSR to NS repository
curl -H "Content-Type: application/json" -X  POST --d @int-slm-repositories/resources/nsr.json http://api.int.sonata-nfv.eu:4002/records/nsr/ns-instances
