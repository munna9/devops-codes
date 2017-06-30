phenom_user=data_bag_item('credentials','phenom')

node['candidates']['app']['directory_list'].each do |directory_name|
  directory "#{phenom_user['home_directory']}/#{directory_name}" do
    action :delete
  end
end
ecr_undeploy "candidates undeploy" do
  vault_name 'services'
  app_name 'candidates'
end