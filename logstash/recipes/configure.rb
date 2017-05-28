[node['logstash']['conf']['home_directory'], node['logstash']['ssl']['home_directory']].each do |directory_name|
  directory  directory_name do
    recursive true
    action :create
  end
end

certificate=data_bag_item('certificates',node['logstash']['certificate_name'])

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

data_bag('beat_prospectors').each do |data_item|
  beat_grok = data_bag_item('beat_prospectors',data_item)
  node.default['logstash']['grok']['patterns'].merge!(beat_grok['grok_patterns'])
end
node['logstash']['grok']['patterns'].each_pair do |key,value|
  _formatted_array=Array.new
  value['grok_pattern'].each do |pattern_name|
    _formatted_array << "%{#{pattern_name}}"
  end
  node.default['logstash']['grok']['patterns'][key]['grok_pattern']=_formatted_array
end



remote_directory node['logstash']['conf']['patterns_directory'] do
  source "patterns"
  action :create
  notifies :restart, "service[#{node['logstash']['service']['name']}]"
end

cookbook_file node['logstash']['template']['file'] do
  source "#{node['logstash']['template']['name']}.json"
  sensitive true
  action :create
  notifies :restart, "service[#{node['logstash']['service']['name']}]"
end

%w(01-beat-input.conf 10-custom-filters.conf 30-elasticsearch-output.conf).each do |conf_file|
  template "#{node['logstash']['conf']['home_directory']}/#{conf_file}" do
    source "#{conf_file}.erb"
    sensitive true
    action :create
    variables(
      :grok_hash => node['logstash']['grok']['patterns']
    )
    notifies :restart, "service[#{node['logstash']['service']['name']}]"
  end
end