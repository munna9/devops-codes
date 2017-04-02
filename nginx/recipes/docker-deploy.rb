docker_deploy 'Nginx - container' do
  vault_name 'tools'
  app_name 'nginx-lua'
end