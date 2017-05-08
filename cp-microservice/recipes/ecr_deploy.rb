ecr_deploy "cp-microservice Deploy" do
  vault_name 'services'
  app_name 'cp-microservice'
end