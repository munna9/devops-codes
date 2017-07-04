ecr_undeploy "okta-auth undeploy" do
  vault_name 'services'
  app_name 'okta-auth'
end