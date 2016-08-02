#!/bin/bash
# -- run the test-trigger container, which will send a service deployment request, mocking the GK.
export DOCKER_HOST="tcp://sp.int3.sonata-nfv.eu:2375"
set -e
set -x

docker run -it --rm -e broker_host=amqp://guest:guest@10.31.11.36:5672/%2F --name int_slm_ia_trigger slm_ia_trigger


export OS_USERNAME=op_sonata
export OS_PASSWORD=op_s0n@t@
export OS_TENANT_NAME=op_sonata
export OS_AUTH_URL=http://openstack.sonata-nfv.eu:5000/v2.0/


heat stack-delete -y $(heat stack-list | head -n-1 | tail -n+4 | awk '{print $2}')
