ecr_deploy "job-scoring Deploy" do
  vault_name 'services'
  app_name 'job-scoring'
end