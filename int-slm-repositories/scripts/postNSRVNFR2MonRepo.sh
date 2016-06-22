#!/bin/bash

# -- Post NSR/VNFR to Monitoring Repository
curl -H "Content-Type: application/json" -X POST http://sp.int2.sonata-nfv.eu:800/api/v1/service/new -d @int-slm-repositories/resources/monitoring-message.json
