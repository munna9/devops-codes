template node['kafka']['service']['conf_file'] do
  source "#{node['platform_family']}/kafka_service.erb"
end
template "/etc/init.d/#{node['kafka']['service']['name']}" do
  source "#{node['platform_family']}/kafka_init.erb"
  mode '0755'
end
service node['kafka']['service']['name'] do
  supports [:start, :stop, :status, :restart]
  action [:start, :enable]
end