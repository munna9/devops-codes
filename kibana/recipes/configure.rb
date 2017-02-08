directory node['kibana']['conf']['home_directory'] do
  recursive true
  action :create
end
template node['kibana']['conf']['file'] do
  source 'kibana.yml.erb'
  notifies :restart, "service[#{node['kibana']['service']['name']}]"
end
