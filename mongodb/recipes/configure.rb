directory node['mongodb']['storage']['path'] do
  recursive true
  owner node['mongodb']['service']['owner']
  group node['mongodb']['service']['group']
end

mongodb_credentials=data_bag_item('credentials','mongodb')

if node['mongodb']['key_authentication']
  file node['mongodb']['app']['key_file'] do
    content mongodb_credentials['keyfile']
    sensitive true
    mode '0400'
    owner node['mongodb']['service']['owner']
    group node['mongodb']['service']['group']
  end
  template "Mongodb configuration file - Key authentication" do
    path node['mongodb']['conf']['file']
    source 'mongod.conf.erb'
    sensitive true
    notifies :restart, "service[#{node['mongodb']['service']['name']}]"
  end
else
  template "Mongodb configuration file - Plain authentication" do
    path node['mongodb']['conf']['file']
    source 'mongod.conf.erb'
    sensitive true
    notifies :restart, "service[#{node['mongodb']['service']['name']}]"
  end

end
