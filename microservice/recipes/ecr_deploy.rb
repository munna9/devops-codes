ecr_deploy "cp_microservice Deploy" do
  vault_name 'services'
  app_name 'cp_microservice'
end