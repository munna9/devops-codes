template node['kafka']['service']['conf_file'] do
  source "#{node['platform_family']}/kafka_sysconfig.erb"
  sensitive true
  notifies :restart, "service[#{node['kafka']['service']['name']}]"
end
template "/etc/init.d/#{node['kafka']['service']['name']}" do
  source "#{node['platform_family']}/kafka_init.erb"
  sensitive true
  mode '0755'
  notifies :restart, "service[#{node['kafka']['service']['name']}]"
end
service node['kafka']['service']['name'] do
  supports [:start, :stop, :status, :restart]
  action [:start, :enable]
end