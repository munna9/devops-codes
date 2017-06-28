default['kafka']['scala']['version'] = '2.11'
default['kafka']['package']['version'] = '0.10.0.0'
default['kafka']['binary']['package'] = "kafka_#{node['kafka']['scala']['version']}-#{node['kafka']['package']['version']}.tgz"
default['kafka']['package']['uri'] = "http://www-us.apache.org/dist/kafka/#{node['kafka']['package']['version']}/#{node['kafka']['binary']['package']}"

default['kafka']['app']['base_directory'] = '/opt'
default['kafka']['app']['install_directory']="#{node['kafka']['app']['base_directory']}/kafka_#{node['kafka']['scala']['version']}-#{node['kafka']['package']['version']}"
default['kafka']['app']['home_directory'] = "#{node['kafka']['app']['base_directory']}/kafka"

default['kafka']['conf']['home_directory'] = "#{node['kafka']['app']['home_directory']}/config"

default['kafka']['service']['name']='kafka'
case node['platform_family']
  when 'rhel'
    default['kafka']['service']['conf_file']="/etc/sysconfig/#{node['kafka']['service']['name']}"
  when 'debian'
    default['kafka']['service']['conf_file']="/etc/default/#{node['kafka']['service']['name']}"
end
default['kafka']['service']['port']=9092

default['kafka']['log']['home_directory']='/var/log/kafka'
default['kafka']['data']['directory']="#{node['kafka']['app']['base_directory']}/events_data"

default['kafka']['conf']['log.retention.hours']=168
default['kafka']['conf']['options']={
  'delete.topic.enable'               => true,
  'num.io.threads'                    => 8,
  'socket.send.buffer.bytes'          => 102400,
  'socket.receive.buffer.bytes'       => 102400,
  'socker.request.max.bytes'          => 104857600,
  'num.recovery.threads.per.data.dir' => 1,
  'compression.type'                  => 'gzip',
  'log.retention.check.interval'      => 300000,
  'zookeeper.connection.timeout.ms'   => 1000000,
  'log.retention.hours'               => node['kafka']['conf']['log.retention.hours'],
  'log.dir'                           => node['kafka']['data']['directory']
}