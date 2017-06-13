ecr_undeploy "auth_server undeploy" do
  vault_name 'communities'
  app_name 'login-auth-server'
end