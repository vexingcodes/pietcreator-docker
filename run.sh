#!/bin/bash -eu
docker build . --tag pietcreator
CONTAINER="$(docker run --detach --env RESOLUTION="${RESOLUTION:-1920x1080}" pietcreator)"
IP=$(docker exec "${CONTAINER}" ip addr show dev eth0 | grep inet | awk '{print $2}' | cut -d/ -f1)
echo
echo "PietCreator started at http://${IP}:8080"
echo "It will probably take a few seconds to become available..."
