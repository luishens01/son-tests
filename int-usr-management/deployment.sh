#!/bin/bash
cd ./bss_resources
#curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
#sudo apt-get install -y nodejs
npm install
node ./node_modules/protractor/bin/webdriver-manager update