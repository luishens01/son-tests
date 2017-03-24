#!/bin/bash

cd int-usr-management/bss_resources
./node_modules/grunt/bin/grunt test --host=sp.int3.sonata-nfv.eu --port=25001 --suite=bssUserManagement
