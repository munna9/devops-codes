[node['chef-client']['conf']['directory'], node['chef-client']['log']['directory'], node['chef-client']['lock']['directory']].each do |dir_name|
  directory  dir_name do
    recursive true
    action :create
  end
end
[node['chef-client']['log']['filename'], node['chef-client']['lock']['filename'] ].each do |file_name|
  file  file_name do
    action :create_if_missing
  end
end

cookbook_file node['chef-client']['conf']['encrypted_data_bag_secret'] do
  source 'encrypted_data_bag_secret'
  mode '0644'
  sensitive true
  action :create
end
template node['chef-client']['log']['conf_file'] do
  source 'chef-client-logrotate.erb'
  sensitive true
  action :create
end
