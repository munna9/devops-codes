ecr_undeploy "emailservice undeploy" do
  vault_name 'services'
  app_name 'emailservice'
end