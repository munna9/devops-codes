phenom_user=data_bag_item('credentials','phenom')

git "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['maxmind_repo']['checkout_directory']}" do
  repository node['phenomtrackapi']['maxmind_repo']['uri']
  revision node['phenomtrackapi']['maxmind_repo']['branch']
  action :sync
  user phenom_user['username']
  group phenom_user['primary_group']
end
