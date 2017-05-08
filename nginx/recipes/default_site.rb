[node['nginx']['app']['conf_directory'], node['nginx']['site']['base_directory']].each do |directory_name|
  directory directory_name do
    recursive true
  end
end
remote_directory node['nginx']['site']['default_directory'] do
  source 'html'
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end
template "#{node['nginx']['app']['conf_directory']}/default.conf" do
  source 'default.conf.erb'
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end
