#!/usr/bin/env bash
UNHANDLED_IMAGES=$(sudo docker images | grep "^<none>" | awk {'print $3'})
for EACH_IMAGE in $UNHANDLED_IMAGES;do
    sudo docker rmi $EACH_IMAGE
done