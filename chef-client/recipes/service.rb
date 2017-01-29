template node['chef-client']['service']['conf_file'] do
  source "#{node['platform_family']}/chef-client_service.erb"
  sensitive true
  action :create
  notifies :restart, "service[#{node['chef-client']['service']['name']}]", :delayed
end

template '/etc/init.d/chef-client' do
  source "#{node['platform_family']}/chef-client_init.erb"
  mode '0777'
  sensitive true
  action :create
  notifies :restart, "service[#{node['chef-client']['service']['name']}]", :delayed
end
service 'chef-client' do
  supports [:start, :restart, :status]
  action [:enable,:start]
end
