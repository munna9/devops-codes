phenom_user=data_bag_item('credentials','phenom')

group phenom_user['primary_group']

user phenom_user['username'] do
  gid phenom_user['primary_group']
  uid phenom_user['uid']
  manage_home true
  comment phenom_user['display_name']
  shell phenom_user['shell']
  home phenom_user['home_directory']
end
directory "#{phenom_user['home_directory']}/.ssh" do
  mode '0700'
  owner phenom_user['username']
  group phenom_user['primary_group']
end
file "#{phenom_user['home_directory']}/.ssh/id_rsa" do
  content phenom_user['id_rsa']
  sensitive true
  mode '0600'
  owner phenom_user['username']
  group phenom_user['primary_group']
end
file "#{phenom_user['home_directory']}/.ssh/id_rsa.pub" do
  content phenom_user['id_rsa_pub']
  sensitive true
  mode '0600'
  owner phenom_user['username']
  group phenom_user['primary_group']
end
cookbook_file "#{phenom_user['home_directory']}/.ssh/config" do
  source 'ssh_config'
  mode '0600'
  sensitive true
  owner phenom_user['username']
  group phenom_user['primary_group']
end
directory phenom_user['home_directory'] do
  mode '0700'
  owner phenom_user['username']
  group phenom_user['primary_group']
end

data_json = data_bag_item('credentials','aws')
aws_hash=data_json[node['aws_account_id']]
directory "#{phenom_user['home_directory']}/.aws" do
  mode '0700'
  owner phenom_user['username']
  group phenom_user['primary_group']
end
file "#{phenom_user['home_directory']}/.aws/config" do
  content "[default]\nregion = #{node['aws_region']}"
  mode "0600"
  sensitive true
end
file "#{phenom_user['home_directory']}/.aws/credentials" do
  content "[default]\naws_access_key_id = #{aws_hash['access_key_id']}\naws_secret_access_key = #{aws_hash['secret_access_key']}}"
  mode "0600"
  sensitive true
end