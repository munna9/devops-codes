directory node['elasticsearch']['conf']['home_directory'] do
  recursive true
  action :create
end
directory node['elasticsearch']['app']['home_directory'] do
  owner node['elasticsearch']['service']['owner']
  group node['elasticsearch']['service']['group']
  recursive true
  action :create
end
unicast_hosts=Array.new
if Chef::Config['solo']
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search. ')
else
  search(:node, "role:elasticsearch AND es_cluster_name:#{node['es_cluster_name']}",:filter_result => {'ipaddress':['ipaddress']}).each do |node_name|
    unicast_hosts << node_name['ipaddress']
   end
end
unicast_hosts.delete(node['ipaddress'])
node.default['elasticsearch']['cluster']['options']['discovery.zen.minimum_master_nodes']=unicast_hosts.length
node.default['elasticsearch']['cluster']['options']['discovery.zen.ping.unicast.hosts']=unicast_hosts
template node['elasticsearch']['conf']['file'] do
  source 'elasticsearch-cluster.yml.erb'
  notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
end
