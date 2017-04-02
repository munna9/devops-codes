def parseHostName
  begin
    hostname=node['hostname']
    hostanme=hostname.split('.')[0]
    host_env=hostname.split('-')[0]
    host_role=hostname.split('-')[1]
    host_role=host_role.gsub(/[^a-zA-Z]/,'')
  rescue
    Chef::Log.error "Hostname not set appropriately, updating to _default-dummy host"
    hostname='_default-dummy01'
    host_env=hostname.split('-')[0]
    host_role=hostname.split('-')[1]
    host_role=host_role.gsub(/[^a-zA-Z]/,'')
  ensure
    node.default['host_env']=host_env
    node.default['host_role']=host_role
  end
end
