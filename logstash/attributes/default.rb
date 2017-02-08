default['logstash']['package']['name']='logstash'
case node['platform']
  when 'debian', 'ubuntu'
    default['logstash']['package']['version']='1:5.2.0-1'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['logstash']['package']['version']='5.2.0-1'
end

default['logstash']['service']['name']='logstash'
default['logstash']['service']['owner']='logstash'
default['logstash']['service']['group']='logstash'

default['logstash']['service']['port']='5004'

default['logstash']['app']['home_directory']='/usr/share/logstash'
default['logstash']['conf']['home_directory']="/etc/logstash/conf.d"

default['logstash']['ssl']['home_directory']="#{node['logstash']['app']['home_directory']}/ssl_certs"
default['logstash']['ssl']['cert']="#{node['logstash']['ssl']['home_directory']}/#{node['logstash']['certificate_name']}.crt"
default['logstash']['ssl']['key']="#{node['logstash']['ssl']['home_directory']}/#{node['logstash']['certificate_name']}.key"

default['logstash']['template']['name']='logstash-template'
default['logstash']['template']['file']="#{node['logstash']['app']['home_directory']}/#{node['logstash']['template']['name']}.json"
