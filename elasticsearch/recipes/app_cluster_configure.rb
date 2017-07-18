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
  search(:node, "role:elasticsearch AND es_cluster_name:#{node['es_cluster_name']}",:filter_result => {'ipaddress':['ipaddress']}).each do |node_name|
    unicast_hosts << node_name['ipaddress']
   end
end
node.default['elasticsearch']['cluster']['options'][node['elasticsearch']['package']['version']]['discovery.zen.minimum_master_nodes']=(unicast_hosts.length/2)+1
unicast_hosts.delete(node['ipaddress'])
node.default['elasticsearch']['cluster']['options'][node['elasticsearch']['package']['version']]['discovery.zen.ping.unicast.hosts']=unicast_hosts
template node['elasticsearch']['conf']['file'] do
  source 'elasticsearch-cluster.yml.erb'
  variables(
    :cluster_name => node['es_cluster_name']
  )
  notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
end
template '/etc/sysconfig/elasticsearch' do
  source 'elasticsearch_sysconfig.erb'
  notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
end

if node['elasticsearch']['nginx']['shield']
  directory node['nginx']['app']['conf_directory'] do
    recursive true
    action :create
  end
  cookbook_file "#{node['nginx']['app']['conf_directory']}/passwords" do
    source "#{node.chef_environment}/passwords"
    mode '0444'
  end
  template "#{node['nginx']['app']['conf_directory']}/elasticsearch.conf" do
    source 'elasticsearch.conf.erb'
    variables(
      :elastic_host => node['ipaddress'],
      :elastic_port => node['elasticsearch']['server_port']
    )
    sensitive true
    notifies :restart, "service[#{node['nginx']['service']['name']}]"
  end
end
