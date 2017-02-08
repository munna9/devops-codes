directory node['elasticsearch']['conf']['home_directory'] do
  recursive true
  action :create
end
template node['elasticsearch']['conf']['file'] do
  source 'elasticsearch.yml.erb'
  sensitive true
  notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
end