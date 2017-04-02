remote_file  node['aws']['inspector_agent']['binary_path'] do
  source node['aws']['inspector_agent']['uri']
  mode '0777'
  sensitive true
  notifies :run, 'execute[install-aws-inspector-agent]', :immediately
end
execute 'install-aws-inspector-agent' do
  command "bash #{node['aws']['inspector_agent']['binary_path']}"
  action :nothing
end
