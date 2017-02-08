service node['filebeat']['service']['name'] do
  action [:stop , :disable]
end
package node['filebeat']['package']['name']  do
  version node['filebeat']['package']['version']
  action :remove
end
directory node['filebeat']['conf']['base_directory'] do
  recursive true
  action :delete
end