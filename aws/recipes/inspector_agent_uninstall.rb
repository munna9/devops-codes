file node['aws']['inspector_agent']['binary_path'] do
  action :delete
end
package node['aws']['inspector_agent']['binary_name'] do
  action :remove
end