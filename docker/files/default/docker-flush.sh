#!/usr/bin/env bash
STOPPED_CONTAINERS=$(sudo docker ps -qf "status=exited")
for EACH_CONTAINER in $STOPPED_CONTAINERS;do
    sudo docker rm $EACH_CONTAINER
done