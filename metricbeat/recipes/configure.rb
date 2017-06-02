begin
  procs_to_watch=data_bag_item('beat_prospectors',node.chef_environment)
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  procs_to_watch=data_bag_item('beat_prospectors',"_default")
end
procs_to_watch['app_procs_to_watch'].each_pair do |app_name,app_hash|
  recipe_name="#{app_name}::install"
  unless node['recipes'].include?(recipe_name)
    procs_to_watch['app_procs_to_watch'].delete(app_name)
  end
end
node.default['metricbeat']['procs_to_watch'].merge!(procs_to_watch['app_procs_to_watch'])
node['metricbeat']['procs_to_watch'].each do |app,app_hash|
    if app_hash['ports']
      _hosts=Array.new
      app_hash['ports'].each do |_port_number|
        _hosts << "#{node['hostname']}:#{_port_number}"
      end
      node.default['metricbeat']['procs_to_watch'][app]['hosts'] = _hosts
    end
end
template node['metricbeat']['conf']['file'] do
  source 'metricbeat.yml.erb'
  sensitive true
  mode '0400'
  variables(
    :procs_to_watch => node['metricbeat']['procs_to_watch']
  )
  notifies :restart, "service[#{node['metricbeat']['service']['name']}]"
end
file "#{node['metricbeat']['conf']['base_directory']}/metricbeat.full.yml" do
  action :delete
  notifies :restart, "service[#{node['metricbeat']['service']['name']}]"
end
