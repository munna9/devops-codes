ecr_deploy "phenomtrack-api Deploy" do
  vault_name 'services'
  app_name 'phenomtrackapi'
end
