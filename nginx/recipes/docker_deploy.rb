directory node['nginx']['app']['conf_directory'] do
  recursive true
end
docker_deploy 'Nginx - container' do
  vault_name 'tools'
  app_name 'nginx-lua'
end