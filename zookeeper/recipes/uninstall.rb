service node['zookeeper']['service']['name'] do
  action [:disable, :stop]
end
[ node['zookeeper']['service']['conf_file'],"/etc/init.d/#{node['zookeeper']['service']['name']}","#{Chef::Config['file_cache_path']}/#{node['zookeeper']['package']['name']}" ].each do |file_name|
  file file_name do
    action :delete
  end
end

[node['zookeeper']['conf']['dataDir'],node['zookeeper']['conf']['dataLogDir'],node['zookeeper']['app']['install_directory']].each do |directory_name|
  directory directory_name do
    recursive true
    action :delete
  end
end
link node['zookeeper']['app']['home_directory'] do
  action :delete
end
