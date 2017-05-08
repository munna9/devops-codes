ecr_deploy "savejobs-service Deploy" do
  vault_name 'services'
  app_name 'savejobs-service'
end