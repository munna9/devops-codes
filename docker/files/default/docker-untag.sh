#!/usr/bin/env bash
IMAGE_LIST=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -E -v ':release*|:[A-Z]-*|^phenompeople')
for EACH_IMAGE in $IMAGE_LIST;do
	docker rmi $EACH_IMAGE
done