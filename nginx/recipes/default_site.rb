template "#{node['nginx']['app']['conf_directory']}/default.conf" do
  source 'default.conf.erb'
  sensitive true
  notifies :restart, "service[#{node['nginx']['service']['name']}]"
end
