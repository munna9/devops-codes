#!/usr/bin/env bash
IMAGES_TO_REMOVE=$(docker images -f "dangling=true" -q)
if [ -z "IMAGES_TO_REMOVE"]; then
  docker rmi $IMAGES_TO_REMOVE
fi
