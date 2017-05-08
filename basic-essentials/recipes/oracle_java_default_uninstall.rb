if node['os'] == 'linux'
  link node['oracle_java']['app']['default_path'] do
    action :delete
  end
  link '/etc/alternatives/java' do
    action :delete
  end
  directory node['oracle_java']['default']['home_directory'] do
    recursive true
    action :delete
  end
  file "#{Chef::Config[:file_cache_path]}/#{node['oracle_java']['default']['binary_package']}" do
    action :delete
  end
end
