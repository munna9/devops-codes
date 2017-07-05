service node['kafka']['service']['name'] do
  supports [:start, :stop, :status, :restart]
  action [:stop, :disable]
end
[ node['kafka']['service']['conf_file'],"/etc/init.d/#{node['kafka']['service']['name']}","#{Chef::Config['file_cache_path']}/#{node['kafka']['binary']['package']}" ].each do |file_name|
  file file_name do
    action :delete
  end
end

[node['kafka']['app']['install_directory'],node['kafka']['data']['directory'], node['kafka']['conf']['home_directory'],node['kafka']['log']['home_directory']].each do |directory_name|
  directory directory_name do
    recursive true
    action :delete
  end
end
link node['kafka']['app']['install_directory'] do
  action :delete
end