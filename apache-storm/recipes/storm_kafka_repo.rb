phenom_user=data_bag_item('credentials','phenom')

git "#{phenom_user['home_directory']}/#{node['storm']['kafka-repo']['checkout_directory']}" do
  repository node['storm']['kafka-repo']['uri']
  revision node['storm']['kafka-repo']['branch']
  action :sync
  user phenom_user['username']
  group phenom_user['primary_group']
end