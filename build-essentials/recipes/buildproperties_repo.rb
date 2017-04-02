phenom_user=data_bag_item('credentials','phenom')

git "#{phenom_user['home_directory']}/#{node['build-essentials']['buildproperties_repo']['checkout_directory']}" do
  repository node['build-essentials']['buildproperties_repo']['uri']
  revision node['build-essentials']['buildproperties_repo']['branch']
  action :sync
  user phenom_user['username']
  group phenom_user['primary_group']
end