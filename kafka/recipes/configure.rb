host_hash=get_kafka_hosts
zookeeper_hosts=Array.new
node['zookeeper']['cluster'].each do |_host_name|
  zookeeper_hosts << "#{_host_name}:#{node['zookeeper']['conf']['clientPort']}"

end

[node['kafka']['data']['directory'], node['kafka']['conf']['home_directory'],node['kafka']['log']['home_directory']].each do |directory_name|
  directory  directory_name do
    recursive true
  end
end

%w(kafka-start-server kafka-status).each do |file_name|
  template "#{node['kafka']['app']['home_directory']}/bin/#{file_name}.sh" do
    source "scripts/#{file_name}.sh.erb"
    mode '0755'
  end
end
template "#{node['kafka']['conf']['home_directory']}/zookeeper.properties" do
  source 'zookeeper.properties.erb'
end
template "#{node['kafka']['conf']['home_directory']}/server.properties" do
  source 'server.properties.erb'
  variables(
    :host_hash        => host_hash,
    :zookeeper_hosts  => zookeeper_hosts
  )
  notifies :restart, "service[#{node['kafka']['service']['name']}]"
end