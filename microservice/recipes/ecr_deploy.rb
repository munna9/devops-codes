phenom_user=data_bag_item('credentials','phenom')
node['microservice']['app']['directory_list'].each do |directory_name|
  directory "#{phenom_user['home_directory']}/#{@cookbook_name}/#{directory_name}" do
    recursive true
    owner phenom_user['username']
    group phenom_user['primary_group']
  end
end

ecr_deploy "microservice Deploy" do
  vault_name 'services'
  app_name 'microservice'
end