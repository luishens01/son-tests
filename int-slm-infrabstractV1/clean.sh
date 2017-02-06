#!/bin/bash
# -- run the test-trigger container, which will send a service deployment request, mocking the GK.
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
set -e
set -x

docker run --rm -e broker_host=amqp://guest:guest@10.31.11.36:5672/%2F --name int_slm_ia_trigger slm_ia_trigger /plugin/test_trigger/clean.sh


