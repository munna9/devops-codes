default['zookeeper']['package']['version'] = '3.4.10'
default['zookeeper']['package']['name'] = "zookeeper-#{node['zookeeper']['package']['version']}.tar.gz"
default['zookeeper']['package']['uri'] = "http://www-us.apache.org/dist/zookeeper/zookeeper-#{node['zookeeper']['package']['version']}/#{node['zookeeper']['package']['name']}"

default['zookeeper']['app']['base_directory'] = '/opt'
default['zookeeper']['app']['install_directory'] = "#{node['zookeeper']['app']['base_directory']}/zookeeper-#{node['zookeeper']['package']['version']}"
default['zookeeper']['app']['home_directory']="#{node['zookeeper']['app']['base_directory']}/zookeeper"


default['zookeeper']['service']['name'] = 'zookeeper'

default['zookeeper']['conf']['home_directory'] = "#{node['zookeeper']['app']['home_directory']}/conf"
case node['platform_family']
  when 'rhel'
    default['zookeeper']['service']['conf_file']="/etc/sysconfig/#{node['zookeeper']['service']['name']}"
  when 'debian'
    default['zookeeper']['service']['conf_file']="/etc/default/#{node['zookeeper']['service']['name']}"
end

default['zookeeper']['conf']['dataDir'] = '/var/zookeeper'
default['zookeeper']['conf']['dataLogDir'] = '/var/log/zookeeper'
default['zookeeper']['conf']['clientPort'] = 2181
default['zookeeper']['leader']['connector_port']=2888
default['zookeeper']['leader']['elector_port']=3888
default['zookeeper']['conf']['options']= {
  'dataDir'                 =>  node['zookeeper']['conf']['dataDir'],
  'dataLogDir'              =>  node['zookeeper']['conf']['dataLogDir'],
  'clientPort'              =>  node['zookeeper']['conf']['clientPort'],
  'maxClientCnxns'          =>  0,
  'initLimit'               =>  5,
  'syncLimit'               =>  2,
  'tickTime'                =>  2000,

}