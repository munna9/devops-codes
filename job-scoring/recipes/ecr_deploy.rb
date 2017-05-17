ecr_deploy "job-scoring Deploy" do
  vault_name 'communities'
  app_name 'job-scoring'
end