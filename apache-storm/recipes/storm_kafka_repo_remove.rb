phenom_user=data_bag_item('credentials','phenom')
directory "#{phenom_user['home_directory']}/#{node['storm']['kafka-repo']['checkout_directory']}" do
  recursive true
  action :delete
end