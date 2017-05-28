default['elasticsearch']['package']['name']='elasticsearch'
case node['platform']
  when 'debian', 'ubuntu'
    default['elasticsearch']['package']['version']='5.3.0'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['elasticsearch']['package']['version']='5.3.0-1'
end

default['elasticsearch']['service']['name']='elasticsearch'
default['elasticsearch']['service']['owner']='elasticsearch'
default['elasticsearch']['service']['group']='elasticsearch'

default['elasticsearch']['service']['host']='127.0.0.1'
default['elasticsearch']['service']['port']=8200
default['elasticsearch']['app']['home_directory']='/var/lib/elasticsearch'
default['elasticsearch']['conf']['home_directory']='/etc/elasticsearch'
default['elasticsearch']['conf']['file']="#{node['elasticsearch']['conf']['home_directory']}/elasticsearch.yml"

default['elasticsearch']['conf']['options']= {
  'cluster.name'                          => node['elasticsearch']['cluster_name'],
  'node.name'                             => '${HOSTNAME}',
  'network.host'                          => node['ipaddress'],
  'node.master'                           => (node['fqdn'] == node['elasticsearch']['server_name'])? 'true' : 'false',
  'node.data'                             => true,
  'http.host'                             => node['elasticsearch']['service']['host'],
  'http.port'                             => node['elasticsearch']['service']['port'],
  'action.destructive_requires_name'      => true,
  'discovery.zen.ping.unicast.hosts'      => [node['elasticsearch']['server_name']]
}