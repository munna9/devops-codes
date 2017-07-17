docker_deploy 'Nginx - container' do
  vault_name 'tools'
  app_name 'nginx-pod'
end

[node['nginx']['app']['log_directory'] , node['nginx']['app']['conf_directory']].each do |directory_name|
  directory directory_name do
    recursive true
  end
end

data_record = data_bag_item('tools', 'nginx-pod')

if data_record.key?(node.chef_environment)
  data_json = data_record[node.chef_environment]['docker']
  _containers=data_json.keys
  node.default['pod_container_name']=_containers.first
end

docker_container node['pod_container_name'] do
  action :nothing
end

services_pod_entries=data_bag('services')

services_pod_entries.each do |service_name|
  nginx_pod "Nginx - #{service_name}" do
    vault_name 'services'
    app_name service_name
  end
end

communities_pod_entries=data_bag('communities')

communities_pod_entries.each do |community_name|
  nginx_pod "Nginx-#{community_name}" do
    vault_name 'communities'
    app_name community_name
  end
end

tools_pod_entries=data_bag('tools')
tools_pod_entries.each do |tool_name|
  nginx_pod "Nginx-#{tool_name}" do
    vault_name 'tools'
    app_name tool_name
  end
end
