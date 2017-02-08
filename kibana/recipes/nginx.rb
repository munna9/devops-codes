template 'Kibana-config' do
  source 'kibana.conf.erb'
  path node['kibana']['nginx']['conf_file']
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end
