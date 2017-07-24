docker_deploy 'Storm-supervisor deploy' do
  vault_name 'communities'
  app_name 'storm-supervisor'
end
_supervisor_container_name=get_container_name 'communities','storm-supervisor'

docker_container _supervisor_container_name do
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
  notifies :restart, "docker_container[#{_supervisor_container_name}]"
end
