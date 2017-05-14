directory node['mongodb']['storage']['path'] do
  recursive true
  owner node['mongodb']['service']['owner']
  group node['mongodb']['service']['group']
end
mongodb_credentials=data_bag_item('credentials','mongodb')
file node['mongodb']['app']['key_file'] do
  content mongodb_credentials['keyfile']
  sensitive true
  mode '0400'
  owner node['mongodb']['service']['owner']
  group node['mongodb']['service']['group']
end
template node['mongodb']['conf']['file'] do
  source 'mongod.conf.erb'
  notifies :restart, "service[#{node['mongodb']['service']['name']}]"
end
