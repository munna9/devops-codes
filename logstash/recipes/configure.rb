
[node['logstash']['conf']['home_directory'], node['logstash']['ssl']['home_directory']].each do |directory_name|
  directory  directory_name do
    recursive true
    action :create
  end
end

case node.chef_environment
  when 'prod'
    certificate=data_bag_item('certificates','prod')
  else
    certificate=data_bag_item('certificates','preprod')
end
file node['logstash']['ssl']['cert'] do
  content certificate['crt']
  owner node['logstash']['service']['owner']
  group node['logstash']['service']['group']
  mode '0600'
  sensitive true
end
file node['logstash']['ssl']['key'] do
  content certificate['key']
  owner node['logstash']['service']['owner']
  group node['logstash']['service']['group']
  mode '0600'
  sensitive true
end

%w(01-beat-input.conf 30-elasticsearch-output.conf).each do |conf_file|
  template "#{node['logstash']['conf']['home_directory']}/#{conf_file}" do
    source "#{conf_file}.erb"
    sensitive true
    action :create
    notifies :restart, "service[#{node['logstash']['service']['name']}]"
  end
end
cookbook_file "#{node['logstash']['conf']['home_directory']}/10-custom-filters.conf" do
  source "10-custom-filters.conf"
  sensitive true
  action :create
  notifies :restart, "service[#{node['logstash']['service']['name']}]"
end

cookbook_file node['logstash']['template']['file'] do
  source "#{node['logstash']['template']['name']}.json"
  sensitive true
  action :create
  notifies :restart, "service[#{node['logstash']['service']['name']}]"
end
