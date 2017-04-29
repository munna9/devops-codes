package node['filebeat']['package']['name'] do
  version node['filebeat']['package']['version'] if node['filebeat']['pin_version']
  action :install
end