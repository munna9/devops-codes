ecr_deploy "auth_server Deploy" do
  vault_name 'communities'
  app_name 'login-auth-server'
end