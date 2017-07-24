docker_deploy 'Storm-Nimbus continer' do
  vault_name 'communities'
  app_name 'storm-nimbus'
end
docker_deploy 'Storm-UI container' do
  vault_name 'communities'
  app_name 'storm-ui'
end

_nimbus_container_name=get_container_name 'communities','storm-nimbus'

docker_container _nimbus_container_name do
  action :nothing
  kill_after node['storm']['container']['kill_after']
  read_timeout node['storm']['container']['read_timeout']
  write_timeout node['storm']['container']['write_timeout']
end
_ui_container_name=get_container_name 'communities','storm-ui'

docker_container _ui_container_name do
  action :nothing
  kill_after node['storm']['container']['kill_after']
  read_timeout node['storm']['container']['read_timeout']
  write_timeout node['storm']['container']['write_timeout']
end
template node['storm']['conf']['file'] do
  source 'storm.yml.erb'
  variables(
    :nimbus_seeds => node['nimbus_seeds'],
    :workers      => node['storm']['worker']['processes']
  )
  notifies :restart, "docker_container[#{_nimbus_container_name}]"
  notifies :restart, "docker_contianer[#{_ui_container_name}]"
end
