#!/bin/bash

# execute tests
printheader "EXECUTE SON-CLI INTEGRATION TESTS & PUSH TO REAL SP-GATEKEEPER"
sudo docker exec son-cli-int-test /bin/bash -c 'cd /tests; ./run-test-push-sp.sh'
