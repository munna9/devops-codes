kibana_hosts=Array.new

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, "role:elk-kibana AND chef_environment:#{node.chef_environment}").each do |kibana_host |
    kibana_hosts << kibana_host['ipaddress']
  end
end

kibana_hosts << node['kibana']['server_name'] if kibana_hosts.empty?

template 'Kibana-config' do
  source 'kibana.conf.erb'
  path node['kibana']['nginx']['conf_file']
  variables(
    :kibana_hosts => kibana_hosts,
    :kibana_port => node['kibana']['service']['port']
  )
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end
