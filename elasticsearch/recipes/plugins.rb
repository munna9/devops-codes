node['elasticsearch']['plugins'][node['elasticsearch']['package']['version']].each do |plugin_name,plugin_metadata|
  case node['elasticsearch']['package']['version']
    when '2.3.5','2.4.5'
      _command = "#{node['elasticsearch']['app']['home_directory']}/bin/plugin install #{plugin_metadata['plugin_name']}/#{plugin_metadata['plugin_version']}"
    else
      _command ="#{node['elasticsearch']['app']['home_directory']}/bin/elasticsearch-plugin install #{plugin_metadata['plugin_name']}"
    end
    execute "install-#{plugin_name}" do
    command _command
    creates "#{node['elasticsearch']['app']['home_directory']}/plugins/#{plugin_metadata['creates']}"
    notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
  end
end
