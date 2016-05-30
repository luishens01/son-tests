#!/bin/bash

CONTAINER=$1

RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

if [ $? -eq 1 ]; then
  echo "'$CONTAINER' does not exist."
  exit
fi

if [ "$RUNNING" == "false" ]; then
  echo "'$CONTAINER' is not running. Remove it."
  docker rm "$CONTAINER"
  exit
fi

echo "$CONTAINER is running. Stop and remove it."
docker stop "$CONTAINER"
docker rm "$CONTAINER"
