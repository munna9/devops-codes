ecr_undeploy "savejobs-service undeploy" do
  vault_name 'services'
  app_name 'savejobs-service'
end