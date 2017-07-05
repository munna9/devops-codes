node['elasticsearch']['plugins'][node['elasticsearch']['package']['version']].each do |plugin_name,plugin_metadata|
  execute "install-#{plugin_name}" do
    command "#{node['elasticsearch']['app']['home_directory']}/bin/plugin install #{plugin_metadata['plugin_name']}/#{plugin_metadata['plugin_version']}"
    creates "#{node['elasticsearch']['app']['home_directory']}/plugins/#{plugin_metadata['creates']}"
    notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
  end
end