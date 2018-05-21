#!/bin/bash

ENV=$1

sed -i -- "s/environment_file/$ENV/g" delete_packages.yml
echo
echo
tavern-ci delete_packages.yml --stdout --debug
echo
sed -i -- "s/$ENV/environment_file/g" delete_packages.yml
echo
