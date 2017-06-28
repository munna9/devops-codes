remote_file "#{Chef::Config['file_cache_path']}/#{node['zookeeper']['package']['name']}" do
  source node['zookeeper']['package']['uri']
end
execute 'extract-zookeeper' do
  command "tar -xzf #{Chef::Config['file_cache_path']}/#{node['zookeeper']['package']['name']} -C #{node['zookeeper']['app']['base_directory']}"
  creates node['zookeeper']['app']['install_directory']
end
link node['zookeeper']['app']['home_directory'] do
  to node['zookeeper']['app']['install_directory']
end