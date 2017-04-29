package node['metricbeat']['package']['name'] do
  version node['metricbeat']['package']['version'] if node['metricbeat']['pin_version']
  action :install
end