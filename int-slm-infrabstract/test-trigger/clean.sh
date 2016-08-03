#!/bin/bash
export OS_USERNAME=op_sonata
export OS_PASSWORD=op_s0n@t@
export OS_TENANT_NAME=op_sonata
export OS_AUTH_URL=http://openstack.sonata-nfv.eu:5000/v2.0/


heat stack-delete -y $(heat stack-list | head -n-1 | tail -n+4 | awk '{print $2}')

