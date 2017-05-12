ecr_undeploy "cp-scoring undeploy" do
  vault_name 'services'
  app_name 'cp-scoring'
end