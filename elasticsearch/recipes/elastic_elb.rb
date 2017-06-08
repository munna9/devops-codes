elasticsearch_hosts=Array.new

if Chef::Config['solo']
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search. ')
else
  search(:node, "role:elasticsearch AND es_cluster_name:#{node['es_cluster_name']}",:filter_result => {'ipaddress':['ipaddress']}).each do |node_name|
    elasticsearch_hosts << node_name['ipaddress']
  end
end
template "#{node['nginx']['app']['conf_directory']}/elastic_elb.conf" do
  source 'elastic_elb.conf.erb'
  variables(
    :hosts_array => elasticsearch_hosts
  )
  notifies :reload, "docker_container[#{node['pod_container_name']}]"
end
