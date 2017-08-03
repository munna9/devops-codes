phenom_user=data_bag_item('credentials','phenom')
directory "#{phenom_user['home_directory']}/#{node['kafka-logs-backup']['config_repo']['checkout_directory']}" do
  recursive true
  action :delete
end
ecr_undeploy "kafka-logs-backup undeploy" do
  vault_name 'services'
  app_name 'kafka-logs-backup'
end
directory node['kafka-logs-backup']['logs']['directory'] do
  recursive true
  action :delete
end
file node['kafka-logs-backup']['cleanup']['script'] do
  action :delete
end
cron @cookbook_name do
  action :delete
end
