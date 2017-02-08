default['elasticsearch']['package']['name']='elasticsearch'
case node['platform']
  when 'debian', 'ubuntu'
    default['elasticsearch']['package']['version']='5.2.0'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['elasticsearch']['package']['version']='5.2.0-1'
end

default['elasticsearch']['service']['name']='elasticsearch'
default['elasticsearch']['service']['owner']='elasticsearch'
default['elasticsearch']['service']['group']='elasticsearch'

default['elasticsearch']['conf']['home_directory']='/etc/elasticsearch'
default['elasticsearch']['conf']['file']="#{node['elasticsearch']['conf']['home_directory']}/elasticsearch.yml"

default['elasticsearch']['conf']['options']= {
  'cluster.name' => node['elasticsearch']['cluster_name'],
  'node.name'=> '${HOSTNAME}',
  'network.host' => node['ipaddress']
}