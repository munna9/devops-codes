ecr_deploy "sendgridwebhook Deploy" do
  vault_name 'services'
  app_name 'sendgridwebhook'
end