remote_file "#{Chef::Config['file_cache_path']}/#{node['chefdk']['package']['name'][node['platform_family']]}" do
  source node['chefdk']['download']['uri'][node['platform']][node['platform_version']]
end
package  node['chefdk']['binary']['package'][node['platform_family']] do
  source "#{Chef::Config['file_cache_path']}/#{node['chefdk']['package']['name'][node['platform_family']]}"
  action :install
  not_if { node['platform_family'] == 'debian' }
end
dpkg_package node['chefdk']['binary']['package'][node['platform_family']] do
  source "#{Chef::Config['file_cache_path']}/#{node['chefdk']['package']['name'][node['platform_family']]}"
  action :install
  only_if { node['platform_family'] == 'debian' }
end