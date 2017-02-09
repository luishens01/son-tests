#!/bin/bash
# -- run the test-trigger container, which will send a service deployment request, mocking the GK.
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
set -e
set -x
instanceUuid=$(cat ./int-slm-infrabstractV1/instanceId.conf)

docker run --rm -e broker_host=amqp://guest:guest@sp.int3.sonata-nfv.eu:5672/%2F -e instance_uuid=$instanceUuid --name int_slm_ia_cleaner slm_ia_cleaner /plugin/test-cleaner/clean.sh


