package node['filebeat']['package']['name'] do
  version node['filebeat']['package']['version']
  action :install
end