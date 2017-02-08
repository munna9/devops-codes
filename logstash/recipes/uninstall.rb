service node['logstash']['service']['name'] do
  action[:disable, :stop]
end

package node['logstash']['binary']['name'] do
  version node['logstash']['binary']['version']
  action :remove
end

[node['logstash']['conf']['home_directory'], node['logstash']['ssl']['home_directory']].each do |directory_name|
  directory  directory_name do
    recursive true
    action :remove
  end
end