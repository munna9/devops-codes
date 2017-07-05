zookeeper_hosts=Array.new
node['zookeeper']['cluster'].each do |_host_name|
  zookeeper_hosts << "#{_host_name}:#{node['zookeeper']['conf']['clientPort']}"
end
host_hash=get_kafka_hosts

[node['kafka']['data']['directory'], node['kafka']['conf']['home_directory'],node['kafka']['log']['home_directory']].each do |directory_name|
  directory  directory_name do
    recursive true
  end
end

template "#{node['kafka']['conf']['home_directory']}/server.properties" do
  source 'server.properties.erb'
  sensitive true
  variables(
    :host_hash        => host_hash,
    :zookeeper_hosts  => zookeeper_hosts
  )
  notifies :restart, "service[#{node['kafka']['service']['name']}]"
end