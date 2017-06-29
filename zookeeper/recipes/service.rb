template node['zookeeper']['service']['conf_file'] do
  source "#{node['platform_family']}/zookeeper_sysconfig.erb"
  sensitive true
  notifies :restart, "service[#{node['zookeeper']['service']['name']}]"
end
template "/etc/init.d/#{node['zookeeper']['service']['name']}" do
  source "#{node['platform_family']}/zookeeper_init.erb"
  mode '0755'
  sensitive true
  notifies :restart, "service[#{node['zookeeper']['service']['name']}]"
end

service node['zookeeper']['service']['name'] do
  supports [:start, :stop, :restart]
  action [:start, :enable]
end