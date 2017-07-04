ecr_deploy "okta-auth Deploy" do
  vault_name 'services'
  app_name 'okta-auth'
end