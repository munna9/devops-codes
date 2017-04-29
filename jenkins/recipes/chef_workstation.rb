%w(.chef/keys .chef/trusted_certs).each do |sub_directory_name|
  directory "#{node['jenkins']['app']['home_directory']}/#{sub_directory_name}" do
    recursive true
    action :create
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
  end
end

jenkins_credentials=data_bag_item('credentials','jenkins')

%w(phenompeople-validator.pem jenkins.pem).each do |file_name|
  file "#{node['jenkins']['app']['home_directory']}/.chef/keys/#{file_name}" do
    content jenkins_credentials[file_name]
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
    sensitive true
    action :create
  end
end

chef_server_fqdn=Chef::Config[:chef_server_url].split('//')[1].split('/')[0]
chef_server_crt=chef_server_fqdn.gsub('.','_')

file "#{node['jenkins']['app']['home_directory']}/.chef/trusted_certs/#{chef_server_crt}.crt" do
  content jenkins_credentials["chef_server_crt"]
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  sensitive true
  action :create
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

template "#{node['jenkins']['app']['home_directory']}/.chef/knife.rb" do
  source 'knife.erb'
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  variables(
    'node_name' => jenkins_credentials['nodename']
  )
  sensitive true
  action :create
end
