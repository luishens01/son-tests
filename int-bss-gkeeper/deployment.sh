#!/bin/bash
set -x
set -e

#DEPLOYMENT
cd int-bss-gkeeper/resources
npm install
node ./node_modules/protractor/bin/webdriver-manager update