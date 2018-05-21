#!/bin/bash

ENV=$1

sed -i -- "s/environment_file/$ENV/g" get_packages.yml
echo
echo
tavern-ci get_packages.yml --stdout --debug
echo
sed -i -- "s/$ENV/environment_file/g" get_packages.yml
echo
