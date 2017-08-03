directory node['kafka-logs-backup']['logs']['directory'] do
  mode '1777'
end
template node['kafka-logs-backup']['cleanup']['script'] do
  source 'kafka-logs-backup_cron.sh.erb'
  mode '0755'
  sensitive true
end
cron @cookbook_name do
  hour '5'
  minute '5'
  command node['kafka-logs-backup']['cleanup']['script']
end
docker_container @cookbook_name do
  action :nothing
  kill_after node['docker']['container']['kill_after']
  read_timeout node['docker']['container']['read_timeout']
  write_timeout node['docker']['container']['write_timeout']
end
phenom_user=data_bag_item('credentials','phenom')
git "#{phenom_user['home_directory']}/#{node['kafka-logs-backup']['config_repo']['checkout_directory']}" do
  repository node['kafka-logs-backup']['config_repo']['uri']
  revision node['kafka-logs-backup']['config_repo']['branch']
  action :sync
  user phenom_user['username']
  group phenom_user['primary_group']
  notifies :restart, "docker_container[#{@cookbook_name}]"
end
ecr_deploy "kafka-logs-backup Deploy" do
  vault_name 'services'
  app_name 'kafka-logs-backup'
end
