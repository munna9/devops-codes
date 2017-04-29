template "/etc/init.d/#{node['elastalert']['service']['name']}" do
  source "init/#{node['platform']}/elastalert.erb"
  mode "0777"
end
service node['elastalert']['service']['name'] do
  supports [:start, :stop, :restat, :enable, :disable]
  action [:enable, :start]
end