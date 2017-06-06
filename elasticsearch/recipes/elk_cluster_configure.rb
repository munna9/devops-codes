directory node['elasticsearch']['conf']['home_directory'] do
  recursive true
  action :create
end
directory node['elasticsearch']['app']['data_directory'] do
  owner node['elasticsearch']['service']['owner']
  group node['elasticsearch']['service']['group']
  recursive true
  action :create
end
unicast_hosts=Array.new
if Chef::Config['solo']
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search. ')
else
  search(:node, "role:elk-elasticsearch AND elk_cluster_name:#{node['elk_cluster_name']}",:filter_result => {'ipaddress':['ipaddress']}).each do |node_name|
    unicast_hosts << node_name['ipaddress']
  end
end
node.default['elasticsearch']['cluster']['options'][node['elasticsearch']['package']['version']]['discovery.zen.minimum_master_nodes']=(unicast_hosts.length/2)+1
node.default['elasticsearch']['cluster']['options'][node['elasticsearch']['package']['version']]['discovery.zen.ping.unicast.hosts']=unicast_hosts
template node['elasticsearch']['conf']['file'] do
  source 'elasticsearch-cluster.yml.erb'
  variables(
    :cluster_name =>node['elk_cluster_name']
  )
  notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
end

directory node['nginx']['app']['conf_directory'] do
	recursive true
	action :create
end
template "#{node['nginx']['app']['conf_directory']}/elasticsearch.conf" do
  source 'elasticsearch.conf.erb'
  sensitive true
  notifies :restart, "service[#{node['nginx']['service']['name']}]"
end