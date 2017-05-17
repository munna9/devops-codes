ecr_deploy "cp-scoring Deploy" do
  vault_name 'communities'
  app_name 'cp-scoring'
end