#!/bin/bash

# execute tests
printheader "EXECUTE SON-CLI INTEGRATION TESTS & PUSH TO EMU-GK"
sudo docker exec son-cli-int-test /bin/bash -c 'cd /tests; ./run-test-push-emu.sh'