package node['logstash']['package']['name'] do
  version node['logstash']['package']['version']
  action :install
  notifies :run, 'execute[logstash-init-script]', :immediately
end
execute 'logstash-init-script' do
  command "#{node['logstash']['app']['home_directory']}/bin/system-install"
  action :nothing
end