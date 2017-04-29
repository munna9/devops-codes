[node['filebeat']['conf']['home_directory'], node['filebeat']['ssl']['home_directory']]. each do |dir_name|
  directory  dir_name do
    recursive true
  end
end

certificate=data_bag_item('certificates',node['logstash']['certificate_name'])

file node['filebeat']['ssl']['cert'] do
  content certificate['crt']
  sensitive true
end

file "#{node['filebeat']['conf']['base_directory']}/filebeat.full.yml" do
  action :delete
  notifies :restart, "service[#{node['filebeat']['service']['name']}]"
end
logstash_servers=Array.new
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, "role:elk-logstash AND chef_environment:#{node.chef_environment}").each do |logstash_host|
    logstash_servers << "#{logstash_host['fqdn'].to_s}:#{node['logstash']['server_port']}"
  end
end
logstash_servers << "#{node['logstash']['server_name']}:#{node['logstash']['server_port']}" if logstash_servers.empty?

template node['filebeat']['conf']['file'] do
  source 'filebeat.yml.erb'
  sensitive true
  variables(
    :logstash_servers_list => logstash_servers
  )
  notifies :restart, "service[#{node['filebeat']['service']['name']}]"
end
