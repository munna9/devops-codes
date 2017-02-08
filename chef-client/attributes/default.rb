default['chef-client']['binary']['path']='/usr/bin/chef-client'

default['chef-client']['conf']['directory']='/etc/chef'
default['chef-client']['conf']['encrypted_data_bag_secret']="#{node['chef-client']['conf']['directory']}/encrypted_data_bag_secret"

default['chef-client']['service']['name']='chef-client'

default['chef-client']['conf']['client_file']="#{node['chef-client']['conf']['directory']}/client.rb"

case node['platform_family']
  when 'rhel'
    default['chef-client']['service']['conf_file']="/etc/sysconfig/#{node['chef-client']['service']['name']}"
  when 'debian'
    default['chef-client']['service']['conf_file']="/etc/default/#{node['chef-client']['service']['name']}"
end

default['chef-client']['log']['directory']='/var/log/chef'
default['chef-client']['log']['conf_file']="/etc/logrotate.d/#{node['chef-client']['service']['name']}"
default['chef-client']['log']['filename']="#{node['chef-client']['log']['directory']}/client.log"

default['chef-client']['lock']['directory']='/var/lock/subsys'
default['chef-client']['lock']['filename']="#{node['chef-client']['lock']['directory']}/#{node['chef-client']['service']['name']}"

case node.chef_environment
  when 'tools'
    default['chef-client']['pool']['interval']='300'
    default['chef-client']['pool']['splay']='200'
  else
    default['chef-client']['pool']['interval']='900'
    default['chef-client']['pool']['splay']='300'
end