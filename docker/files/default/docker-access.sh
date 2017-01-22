#!/usr/bin/env bash
CONTAINER_NAME=$1
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <CONTAINERID/CONTAINTERNAME>"
    RUNNING_CONTAINERS=$(sudo docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}")
    echo "Available Containers on your machine"
    echo "$RUNNING_CONTAINERS"
    printf '%20s\n' | tr ' ' -
    read -p "Provide Container ID/Name : " CONTAINER_NAME
fi
sudo docker exec -it $CONTAINER_NAME /bin/bash