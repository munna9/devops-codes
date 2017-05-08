ecr_undeploy "cp-emailservice undeploy" do
  vault_name 'services'
  app_name 'cp-emailservice'
end