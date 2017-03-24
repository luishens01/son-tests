#!/bin/bash

cd int-service-instantiation/resources
./node_modules/grunt/bin/grunt test --host=sp.int3.sonata-nfv.eu --port=25001 --suite=service_Instantiation

# -- Retrieve information
#int-service-instantiation/scripts/getModulesInfoFromGraylog.sh
