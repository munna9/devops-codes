phenom_user=data_bag_item('credentials','phenom')

node['candidates']['app']['directory_list'].each do |directory_name|
  directory "#{phenom_user['home_directory']}/#{@cookbook_name}/#{directory_name}" do
    recursive true
    mode '1777'
  end
end
ecr_deploy "candidates Deploy" do
  vault_name 'services'
  app_name 'candidates'
end