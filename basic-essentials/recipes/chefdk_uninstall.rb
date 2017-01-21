package node['chefdk']['binary']['package'][node['platform_family']] do
  action :remove
end
file "#{Chef::Config['file_cache_path']}/#{node['chefdk']['package']['name'][node['platform_family']]}" do
  action :delete
end
