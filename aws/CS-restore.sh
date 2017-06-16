#!/bin/bash

aws s3 cp s3://<bucket_name>/<path>/<file_name>  /home/vagrant/backup/
sudo chef-server-ctl reconfigure
sudo chef-server-ctl restore /home/vagrant/backup/*.tgz --cleanse

