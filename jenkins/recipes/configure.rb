group node['jenkins']['service']['group']

user node['jenkins']['service']['owner'] do
  comment 'Jenkins User'
  gid node['jenkins']['service']['group']
  home node['jenkins']['app']['home_directory']
  shell '/bin/bash'
end

group node['docker']['service']['group'] do
  members node['jenkins']['service']['owner']
  append true
  action :modify
end

directory "#{node['jenkins']['app']['home_directory']}/.ssh" do
  recursive true
  action :create
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
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

file "#{node['jenkins']['app']['home_directory']}/.ssh/authorized_keys" do
  content jenkins_credentials['id_rsa.pub']
  mode '0600'
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  sensitive true
  action :create
end


if node['aws_account_id']
  data_json=data_bag_item('credentials','aws')
  template "#{node['jenkins']['app']['home_directory']}/admin_policy.json" do
    source 'admin_policy.json.erb'
    variables(
      :account_id => node['aws_account_id']
    )
    sensitive true
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
  end
  aws_hash=data_json[node['aws_account_id']]
  phemom_data=data_bag_item('credentials','phemom')
  directory "#{node['jenkins']['app']['home_directory']}/.aws" do
    recursive true
    action :create
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
  end
  template "#{node['jenkins']['app']['home_directory']}/.aws/config" do
    source 'aws/config.erb'
    sensitive true
    variables(
      :default_region   => node['aws_region'],
      :phemom_region    => phemom_data['default_region']
    )
    mode 0600
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
  end
  template "#{node['jenkins']['app']['home_directory']}/.aws/credentials" do
    source 'aws/credentials.erb'
    sensitive true
    variables(
      :phemom_aws_access_key_id         =>  phemom_data['access_key_id'],
      :phemom_aws_secret_access_key     =>  phemom_data['secret_access_key']
    )
  end
  template "#{node['jenkins']['app']['home_directory']}/phemom_admin_policy.json" do
    source 'admin_policy.json.erb'
    variables(
      :account_id => phemom_data['aws_account_id']
    )
    sensitive true
    owner node['jenkins']['service']['owner']
    group node['jenkins']['service']['group']
  end
end
