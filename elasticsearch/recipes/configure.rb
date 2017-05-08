directory node['elasticsearch']['conf']['home_directory'] do
  recursive true
  action :create
end
template node['elasticsearch']['conf']['file'] do
  source 'elasticsearch.yml.erb'
  sensitive true
  notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
end
template "#{node['nginx']['app']['conf_directory']}/elasticsearch.conf" do
  source 'elasticsearch.conf.erb'
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end