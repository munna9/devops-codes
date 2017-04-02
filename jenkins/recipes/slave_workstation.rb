group node['jenkins']['service']['group']

user node['jenkins']['service']['owner'] do
  comment 'Jenkins User'
  gid node['jenkins']['service']['group']
  home node['jenkins']['app']['home_directory']
  shell '/bin/bash'
end
%w(.ssh .aws).each do |sub_directory_name|
  directory "#{node['jenkins']['app']['home_directory']}/#{sub_directory_name}" do
    recursive true
    action :create
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
  end
end
cookbook_file "#{node['jenkins']['app']['home_directory']}/.ssh/config" do
  source 'ssh_config'
  mode '0600'
  sensitive true
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  action :create
end

jenkins_credentials=data_bag_item('credentials','jenkins')

%w(id_rsa id_rsa.pub).each do |file_name|
  file "#{node['jenkins']['app']['home_directory']}/.ssh/#{file_name}" do
    content jenkins_credentials[file_name]
    mode '0400'
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
    sensitive true
    action :create
  end
end
group node['docker']['service']['group'] do
  members node['jenkins']['service']['owner']
  append true
  action :modify
end
file "#{node['jenkins']['app']['home_directory']}/.aws/config" do
  content "[default]\nregion = #{node['aws']['region']}"
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  mode "0600"
  sensitive true
end
file "#{node['jenkins']['app']['home_directory']}/.ssh/authorized_keys" do
  content jenkins_credentials['id_rsa.pub']
  mode '0600'
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  sensitive true
  action :create
end
template "#{node['jenkins']['app']['home_directory']}/admin_policy.json" do
  source 'admin_policy.json.erb'
  sensitive true
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
end
directory node['jenkins']['app']['home_directory'] do
  recursive true
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
end