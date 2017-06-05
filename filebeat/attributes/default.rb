default['filebeat']['package']['name']='filebeat'
default['filebeat']['pin_version']=true
case node['platform']
  when 'debian', 'ubuntu'
    default['filebeat']['package']['version']='5.4.0'
    default['filebeat']['host_package']['log_file']='/var/log/dpkg.log'
    default['filebeat']['host_auth']['log_file']='/var/log/auth.log'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['filebeat']['package']['version']='5.4.1-1'
    default['filebeat']['host_package']['log_file']='/var/log/yum.log'
    default['filebeat']['host_auth']['log_file']='/var/log/secure'
end

default['filebeat']['service']['name']='filebeat'

default['filebeat']['conf']['base_directory']='/etc/filebeat'
default['filebeat']['conf']['home_directory']="#{node['filebeat']['conf']['base_directory']}/conf.d"
default['filebeat']['conf']['file']="#{node['filebeat']['conf']['base_directory']}/filebeat.yml"
default['filebeat']['conf']['workers']= 2

default['filebeat']['ssl']['home_directory']="#{node['filebeat']['conf']['base_directory']}/ssl_certs"
default['filebeat']['ssl']['cert']="#{node['filebeat']['ssl']['home_directory']}/#{node['logstash']['certificate_name']}.crt"

default['filebeat']['files_to_watch']={
  'auth-logger' => {
    "document_type" => "auth-log",
    "paths" => [node['filebeat']['host_auth']['log_file']],
    "input_type" => "log",
    "close_inaactive" => "5m",
    "close_renamed" => true,
    "symlink" => "enabled",
    "tail-files" => true
  },
  'chef-client' => {
    "document_type" => "chef-client",
    "paths" => ['/var/log/chef-client.log'],
    "input_type" => "log",
    "close_inactive" => "5m",
    "close_renamed" => true,
    "symlink" => 'enabled',
    "tail-files" => true
  },
  'messages' => {
    "document_type" => "messages",
    "paths" => ['/var/log/messages'],
    "input_type" => "log",
    "close_inactive" => "5m",
    "close_renamed" => true,
    "symlink" => 'enabled',
    "tail-files" => true
  },
  'package-logger' => {
    "document_type" => "package-log",
    "paths" => [node['filebeat']['host_package']['log_file']],
    "input_type" => "log",
    "close_inaactive" => "5m",
    "close_renamed" => true,
    "symlink" => "enabled",
    "tail-files" => true
  }
}