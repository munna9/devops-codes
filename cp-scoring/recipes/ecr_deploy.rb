ecr_deploy "cp-scoring Deploy" do
  vault_name 'services'
  app_name 'cp-scoring'
end