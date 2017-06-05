default['metricbeat']['package']['name']='metricbeat'
default['metricbeat']['pin_version']=true
case node['platform']
  when 'debian', 'ubuntu'
    default['metricbeat']['package']['version']='5.4.0'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['metricbeat']['package']['version']='5.4.1-1'
end

default['metricbeat']['service']['name']='metricbeat'

default['metricbeat']['conf']['base_directory']='/etc/metricbeat'
default['metricbeat']['app']['base_directory']='/usr/share/metricbeat'
default['metricbeat']['conf']['file']="#{node['metricbeat']['conf']['base_directory']}/metricbeat.yml"
default['metricbeat']['conf']['workers']=2

default['metricbeat']['procs_to_watch']= {
  "system" => {
    "module" => "system",
    "metricsets" => ['cpu','filesystem','memory', 'network', 'diskio', 'load'],
  }
}

