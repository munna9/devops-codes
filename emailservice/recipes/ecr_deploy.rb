ecr_deploy "cp-emailservice Deploy" do
  vault_name 'services'
  app_name 'cp-emailservice'
end