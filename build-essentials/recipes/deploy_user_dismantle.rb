phenom_user=data_bag_item('credentials','phenom')


user phenom_user['username'] do
  action :remove
end

group phenom_user['primary_group'] do
  action :remove
end

directory "#{phenom_user['home_directory']}/.ssh" do
  recursive true
  action :delete
end