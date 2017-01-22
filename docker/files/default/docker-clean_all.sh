#!/usr/bin/env bash
ALL_CONTAINERS=$(sudo docker ps -aq)
for EACH_CONTAINER in $ALL_CONTAINERS;do
    sudo docker rm -f $EACH_CONTAINER
done

ALL_IMAGES=$(sudo docker images -q)
for EACH_IMAGE in $ALL_IMAGES;do
    sudo docker rmi -f $EACH_IMAGE
done