#!/bin/bash
printf "\n\n======== POST User Login to GTKUSR ==\n\n\n"


if [[ $code != 200 ]] ;
  then
    echo "Error: Response error $code"
    exit -1
fi