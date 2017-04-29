if node['os'] == 'linux'
  link node['build-essentials']['maven']['app_directory'] do
    action :delete
  end
  directory node['build-essentials']['maven']['home_directory'] do
    recursive true
    action :delete
  end
  file "#{Chef::Config[:file_cache_path]}/#{node['build-essentials']['maven']['binary_package']}" do
    action :delete
  end
end
