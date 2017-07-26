default['elasticsearch']['package']['name'] = 'elasticsearch'
case node['platform']
  when 'debian', 'ubuntu'
    default['elasticsearch']['package']['version'] = '5.3.0'
    default['elasticsearch']['archive']['package'] = "#{node['elasticsearch']['package']['name']}-#{node['elasticsearch']['package']['version']}.deb"
    default['elasticsearch']['package']['installer'] = 'dpkg'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['elasticsearch']['package']['version'] = '5.4.1-1'
    default['elasticsearch']['archive']['package'] = "#{node['elasticsearch']['package']['name']}-#{node['elasticsearch']['package']['version']}.rpm"
    default['elasticsearch']['package']['installer'] = 'rpm'
end
case node['elasticsearch']['package']['version']
  when '2.3.5', '2.4.1', '2.4.5'
    _base_uri = "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/#{node['elasticsearch']['package']['installer']}/#{node['elasticsearch']['package']['name']}/#{node['elasticsearch']['package']['version']}"
  when '5.1.2','5.5.0'
    _base_uri = "https://artifacts.elastic.co/downloads/#{node['elasticsearch']['package']['name']}"
end

default['elasticsearch']['package']['uri'] = "#{_base_uri}/#{node['elasticsearch']['archive']['package']}"

default['elasticsearch']['service']['name'] = 'elasticsearch'
default['elasticsearch']['service']['owner'] = 'elasticsearch'
default['elasticsearch']['service']['group'] = 'elasticsearch'

default['elasticsearch']['nginx']['shield'] = false

default['elasticsearch']['service']['host'] = node['elasticsearch']['nginx']['shield']==true ? '127.0.0.1' : node['ipaddress']
default['elasticsearch']['service']['port'] = node['elasticsearch']['nginx']['shield']==true ? 8200 : node['elasticsearch']['server_port']
default['elasticsearch']['service']['admin_port'] = 8082


default['elasticsearch']['conf']['home_directory'] = '/etc/elasticsearch'
default['elasticsearch']['conf']['file'] = "#{node['elasticsearch']['conf']['home_directory']}/elasticsearch.yml"

default['elasticsearch']['app']['data_directory'] = '/var/lib/elasticsearch'
default['elasticsearch']['app']['home_directory'] = '/usr/share/elasticsearch'
default['elasticsearch']['log']['home_directory'] = '/var/log/elasticsearch'
default['elasticsearch']['plugins'] = {
  '2.3.5' => {
    'siren-join' => {
      'plugin_name'     => 'solutions.siren/siren-join',
      'plugin_version'  => '2.3.5',
      'creates'         => 'siren-join'
    },
    'head' => {
      'plugin_name'     => 'mobz/elasticsearch-head',
      'plugin_version'  => '*',
      'creates'         => 'head'
    }
  },
  '2.4.5' => {
    'siren-join' => {
      'plugin_name'     => 'solutions.siren/siren-join',
      'plugin_version'  => '2.4.5',
      'creates'         => 'siren-join'
    },
    'head' => {
      'plugin_name'     => 'mobz/elasticsearch-head',
      'plugin_version'  => '*',
      'creates'         => 'head'
    }
  },
  '5.5.0' =>{
    'analysis-icu' => {
      'plugin_name'     => 'analysis-icu',
      'plugin_version'  => '*',
      'creates'         =>  'analysis-icu'
    }
  }
}
default['elasticsearch']['cluster']['options'] = {
  '5.5.0' =>{
    'http.host'                             => node['elasticsearch']['service']['host'],
    'http.port'                             => node['elasticsearch']['service']['port'],
    'http.compression'                      => true,
    'action.destructive_requires_name'      => true,
    'http.cors.enabled'                     => true,
    'http.cors.allow-origin'                => '"*"'
  },
  '5.4.1-1'  => {
    'http.host'                             => node['elasticsearch']['service']['host'],
    'http.port'                             => node['elasticsearch']['service']['port'],
    'http.compression'                      => true,
    'action.destructive_requires_name'      => true,
    'action.auto_create_index'              => true,
    'node.master'                           => true,
    'node.data'                             => true,
    'node.max_local_storage_nodes'          => 1,
  },
  '5.3.0-1'  => {
    'http.host'                             => node['elasticsearch']['service']['host'],
    'http.port'                             => node['elasticsearch']['service']['port'],
    'http.compression'                      => true,
    'action.destructive_requires_name'      => true,
    'action.auto_create_index'              => true,
    'node.master'                           => true,
    'node.data'                             => true,
    'node.max_local_storage_nodes'          => 1,
  },
  '2.4.5' => {
    'http.host'                             => node['elasticsearch']['service']['host'],
    'http.port'                             => node['elasticsearch']['service']['port'],
    'http.compression'                      => true,
    'action.destructive_requires_name'      => true,
    'action.auto_create_index'              => false,
    'node.master'                           => true,
    'node.data'                             => true,
    'bootstrap.mlockall'                    => true,
    'discovery.zen.ping.multicast.enabled'  => false,
    'node.max_local_storage_nodes'          => 1,
    'node.number_of_shards'                 => 3,
  },
  '2.3.5' => {
    'http.host'                             => node['elasticsearch']['service']['host'],
    'http.port'                             => node['elasticsearch']['service']['port'],
    'http.compression'                      => true,
    'action.destructive_requires_name'      => true,
    'action.auto_create_index'              => false,
    'node.master'                           => true,
    'node.data'                             => true,
    'bootstrap.mlockall'                    => true,
    'discovery.zen.ping.multicast.enabled'  => false,
    'node.max_local_storage_nodes'          => 1,
    'node.number_of_shards'                 => 3,
  }
}