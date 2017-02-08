service node['elasticsearch']['service']['name'] do
  action [:stop, :disable]
end
package node['elasticsearch']['package']['name'] do
  version node['elasticsearch']['package']['version']
  action :remove
end
directory node['elasticsearch']['conf']['home_directory'] do
  recursive true
  action :delete
end