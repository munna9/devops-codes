directory  node['logstash']['conf']['home_directory'] do
  recursive true
  action :create
  not_if { ::File.exist?(node['logstash']['conf']['home_directory'])}
end
%w(02-http-input.conf).each do |conf_file|
  template "#{node['logstash']['conf']['home_directory']}/#{conf_file}" do
    source "#{conf_file}.erb"
    sensitive true
    action :create
    notifies :restart, "service[#{node['logstash']['service']['name']}]"
  end
end