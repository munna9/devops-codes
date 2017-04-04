file "#{node['metricbeat']['app']['base_directory']}/scripts/es_dashboards" do
  content "/usr/share/metricbeat/scripts/import_dashboards -es http://#{node['elasticsearch']['server_name']}:#{node['elasticsearch']['server_port']}"
  mode '0777'
  notifies :run, 'execute[run_es_dashboards]', :immediately
end

execute 'run_es_dashboards' do
  command "#{node['metricbeat']['app']['base_directory']}/scripts/es_dashboards"
  action :nothing
end