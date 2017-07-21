phenom_user=data_bag_item('credentials','phenom')

directory "#{phenom_user['home_directory']}/#{node['phenomtrackapi']['maxmind_repo']['checkout_directory']}" do
  recursive true
  action :delete
end