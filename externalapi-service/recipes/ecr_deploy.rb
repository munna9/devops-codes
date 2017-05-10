ecr_deploy "externalapi-service Deploy" do
  vault_name 'services'
  app_name 'externalapi-service'
end