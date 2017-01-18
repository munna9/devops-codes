remote_file "#{Chef::Config['file_cache_path']}/#{node['chefdk']['binary']['package'][node['platform_family']]}" do
  source node['chefdk']['download']['uri'][node['platform']][node['platform_version']]
end
package "#{Chef::Config['file_cache_path']}/#{node['chefdk']['binary']['package'][node['platform_family']]}" do
  action :install
end