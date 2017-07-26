phenom_user=data_bag_item('credentials','phenom')

git "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['maxmind_repo']['checkout_directory']}" do
  repository node['phenomtrackapi']['maxmind_repo']['uri']
  revision node['phenomtrackapi']['maxmind_repo']['branch']
  action :sync
  user phenom_user['username']
  group phenom_user['primary_group']
  notifies :restart, "docker_container[#{@cookbook_name}]"
end

zk_hosts=Array.new
node['zookeeper']['cluster'].each do |host_name|
  zk_hosts << "#{host_name}:#{node['zookeeper']['conf']['clientPort']}"
end

kafka_hosts=Array.new
node['kafka']['cluster'].each do |host_name|
  kafka_hosts << "#{host_name}:#{node['kafka']['service']['port']}"
end

directory "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['conf']['base_directory']}" do
  recursive true
  action :create
end
docker_container "#{@cookbook_name}" do
  action :nothing
end
template "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['conf']['file']}" do
  source 'config.json.erb'
  variables(
    :maxmind_directory => "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['maxmind_repo']['checkout_directory']}",
    :zk_hosts          => zk_hosts,
    :kafka_hosts       => kafka_hosts
  )
  notifies :restart, "docker_container[#{@cookbook_name}]"
end
template "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['conf']['base_directory']}/log4j.properties" do
  source 'log4j.properties.erb'
  sensitive true
  notifies :restart, "docker_container[#{@cookbook_name}]"
end
