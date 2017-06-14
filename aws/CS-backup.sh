#!/usr/bin/env bash

chef-server-ctl backup --yes
aws s3 cp /var/opt/chef-backup/*.tgz s3://<bucket_name>/<path>/
rm -rf /var/opt/chef-backup/*.tgz
