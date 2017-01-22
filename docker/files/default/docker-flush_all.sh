#!/usr/bin/env bash
ALL_CONTAINERS=$(sudo docker ps -aq)
for EACH_CONTAINER in $ALL_CONTAINERS;do
    sudo docker rm -f $EACH_CONTAINER
done
