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
echo "Stopping $CONTAINER_NAME"
RESULT=$(sudo docker stop $CONTAINER_NAME)
echo "Removing $CONTAINER_NAME"
RESULT=$(sudo docker rm $CONTAINER_NAME)
