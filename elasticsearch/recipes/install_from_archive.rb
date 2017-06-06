remote_file "#{Chef::Config['file_cache_path']}/#{node['elasticsearch']['archive']['package']}" do
  source node['elasticsearch']['package']['uri']
  notifies :run, 'execute[install-elasticsearch]', :immediately
end

execute 'install-elasticsearch' do
  cwd Chef::Config['file_cache_path']
  command "#{node['elasticsearch']['package']['installer']} -i #{node['elasticsearch']['archive']['package']}"
  action :nothing
end
