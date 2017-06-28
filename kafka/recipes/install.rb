remote_file "#{Chef::Config['file_cache_path']}/#{node['kafka']['binary']['package']}" do
  source node['kafka']['package']['uri']
end
execute 'extract-kafka' do
  command "tar -xf #{Chef::Config['file_cache_path']}/#{node['kafka']['binary']['package']} -C #{node['kafka']['app']['base_directory']}"
  creates node['kafka']['app']['install_directory']
end

link node['kafka']['app']['home_directory'] do
  to node['kafka']['app']['install_directory']
end
