service node['metricbeat']['service']['name'] do
  action [:stop , :disable]
end
package node['metricbeat']['package']['name']  do
  version node['metricbeat']['package']['version']
  action :remove
end
directory node['metricbeat']['conf']['base_directory'] do
  recursive true
  action :delete
end