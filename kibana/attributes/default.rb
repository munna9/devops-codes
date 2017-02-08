default['kibana']['package']['name']='kibana'
case node['platform']
  when 'debian', 'ubuntu'
    default['kibana']['package']['version']='5.2.0'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['kibana']['package']['version']='5.2.0-1'
end
default['kibana']['service']['name']='kibana'
default['kibana']['service']['port']=5601

default['kibana']['service']['uri']='localhost'

default['kibana']['conf']['home_directory']='/etc/kibana'
default['kibana']['conf']['file']="#{node['kibana']['conf']['home_directory']}/kibana.yml"
default['kibana']['nginx']['conf_file']="#{node['nginx']['app']['conf_directory']}/kibana.conf"
default['kibana']['index']['name']='.kibana'
