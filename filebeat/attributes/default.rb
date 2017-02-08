default['filebeat']['package']['name']='filebeat'
case node['platform']
  when 'debian', 'ubuntu'
    default['filebeat']['package']['version']='5.2.0'
    default['filebeat']['package']['log_file']='/var/log/dpkg.log'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['filebeat']['package']['version']='5.2.0-1'
    default['filebeat']['package']['log_file']='/var/log/yum.log'
end

default['filebeat']['service']['name']='filebeat'

default['filebeat']['conf']['base_directory']='/etc/filebeat'
default['filebeat']['conf']['home_directory']="#{node['filebeat']['conf']['base_directory']}/conf.d"
default['filebeat']['conf']['file']="#{node['filebeat']['conf']['base_directory']}/filebeat.yml"
default['filebeat']['conf']['workers']= 2

default['filebeat']['ssl']['home_directory']="#{node['filebeat']['conf']['base_directory']}/ssl_certs"
default['filebeat']['ssl']['cert']="#{node['filebeat']['ssl']['home_directory']}/#{node['logstash']['certificate_name']}.crt"

default['filebeat']['files_to_watch']={
  'chef-client' => {
    "input_type" => "log",
    "document_type" => "lastlog",
    "paths" => ['/var/log/chef/client.log'],
    "close_inactive" => "5m",
    "close_renamed" => true,
    "symlink" => 'enabled',
    "tail-files" => true
  },
  'package-logger' => {
    "input_type" => "log",
    "document_type" => "package_log",
    "paths" => [node['filebeat']['package']['log_file']],
    "close_inaactive" => "5m",
    "close_renamed" => true,
    "symlink" => "enabled",
    "tail-files" => true
  }
}