package node['metricbeat']['package']['name'] do
  version node['metricbeat']['package']['version']
  action :install
end