ecr_deploy "phenom gateway service Deploy" do
  vault_name 'services'
  app_name 'phenom-gateway-service'
end
