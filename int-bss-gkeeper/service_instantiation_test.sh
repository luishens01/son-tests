#!/bin/bash

cd int-bss-gkeeper/resources
./node_modules/grunt/bin/grunt test --host=sp.int3.sonata-nfv.eu --port=25001 --suite=service_Instantiation --protocol=https