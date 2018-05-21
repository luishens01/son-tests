#!/bin/bash

ENV=$1

sed -i -- "s/environment_file/$ENV/g" get_admin_logs.yml
echo
echo
tavern-ci get_admin_logs.yml --stdout --debug
echo
sed -i -- "s/$ENV/environment_file/g" get_admin_logs.yml
echo