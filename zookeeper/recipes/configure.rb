[node['zookeeper']['conf']['dataDir'],node['zookeeper']['conf']['dataLogDir']].each do |directory_name|
  directory directory_name do
    recursive true
  end
end

zk_host_hash=get_zk_hosts

file "#{node['zookeeper']['conf']['dataDir']}/myid" do
  content "#{zk_host_hash[node['hostname']]['myId']}"
end
template node['zookeeper']['conf']['file'] do
  source 'zoo.cfg.erb'
  sensitive true
  variables(
    :host_hash => zk_host_hash
  )
  notifies :restart, "service[#{node['zookeeper']['service']['name']}]"
end