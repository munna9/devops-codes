service node['kibana']['service']['name'] do
  action [:stop, :disable]
end
package node['kibana']['package']['name'] do
  version node['kibana']['package']['version']
  action :remove
end
directory node['kibana']['conf']['base_directory'] do
  recursive true
  action :delete
end