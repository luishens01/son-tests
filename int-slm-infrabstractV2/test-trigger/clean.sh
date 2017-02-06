#!/bin/bash
export OS_USERNAME=admin
export OS_PASSWORD=ii70mseq
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://10.100.32.200:5000/v2.0/


heat stack-delete -y $(heat stack-list | head -n-1 | tail -n+4 | awk '{print $2}')

