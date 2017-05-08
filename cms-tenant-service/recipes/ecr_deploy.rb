ecr_deploy "cms-tenant-service Deploy" do
  vault_name 'services'
  app_name 'cms-tenant-service'
end