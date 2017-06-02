#!/usr/bin/env bash

CURRENT_TIME=$(date +%Y-%m-%d-%H-%M-%S)
chef-server-ctl backup
aws s3 cp chef-backup-$CURRENT_TIME.gz s3://<bucket_name>/<path>/
