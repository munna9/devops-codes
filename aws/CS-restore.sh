KEY=$(aws s3 ls test-chef-server-backup --recursive | sort | tail -n 1 | awk '{print $4}')
aws s3 cp s3://test-chef-server-backup/$KEY /home/vagrant/backup/
sudo chef-server-ctl reconfigure
sudo chef-server-ctl restore /home/vagrant/backup/*.tgz --cleanse
sudo chef-server-ctl reconfigure

