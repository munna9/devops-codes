ecr_deploy "emailservice Deploy" do
  vault_name 'services'
  app_name 'emailservice'
end