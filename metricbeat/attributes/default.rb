default['metricbeat']['package']['name']='metricbeat'
case node['platform']
  when 'debian', 'ubuntu'
    default['metricbeat']['package']['version']='5.2.1'
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['metricbeat']['package']['version']='5.2.0-1'
end

default['metricbeat']['service']['name']='metricbeat'

default['metricbeat']['conf']['base_directory']='/etc/metricbeat'
default['metricbeat']['conf']['file']="#{node['metricbeat']['conf']['base_directory']}/metricbeat.yml"
default['metricbeat']['conf']['workers']=2
default['metricbeat']['procs_to_watch']= {
  "system" => {
    "module" => "system",
    "metricsets" => ['cpu','filesystem','memory', 'network', 'diskio', 'load'],
  }
}
default['metricbeat']['app']['base_directory']='/usr/share/metricbeat'

