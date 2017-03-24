#!/bin/bash
set -x
set -e
#DEPLOYMENT

cd int-bss-gkeeper/resources
#curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
#sudo apt-get install -y nodejs
npm install
node ./node_modules/protractor/bin/webdriver-manager update
## -- insert NSD/VNFD
../scripts/postCatalogueSampleDescriptors.sh
../scripts/postGatekeeperSampleRequest.sh
