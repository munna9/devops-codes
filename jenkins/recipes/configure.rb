template 'Jenkins-config' do
  source 'jenkins.conf.erb'
  path "#{node['nginx']['app']['conf_directory']}/jenkins.conf"
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end
user node['jenkins']['service']['owner'] do
  shell '/bin/bash'
  action :modify
end

group node['docker']['service']['group'] do
  members node['jenkins']['service']['owner']
  append true
  action :modify
end

cookbook_file "#{Chef::Config['file_cache_path']}/kitchen-docker-2.6.1.phenom.gem" do
  source 'chef/kitchen-docker-2.6.1.phenom.gem'
end
gem_package 'kitchen-docker' do
  gem_binary '/opt/chefdk/embedded/bin/gem'
  source "#{Chef::Config['file_cache_path']}/kitchen-docker-2.6.1.phenom.gem"
  options "--no-user-install"
  action :install
end