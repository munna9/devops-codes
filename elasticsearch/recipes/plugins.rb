node['elasticsearch']['plugins'][node['elasticsearch']['package']['version']].each do |plugin_name,plugin_version|
  base_name=plugin_name.split('/')[1]
  execute "install-#{plugin_name}" do
    command "#{node['elasticsearch']['app']['home_directory']}/bin/plugin install #{plugin_name}/#{plugin_version}"
    creates "#{node['elasticsearch']['app']['home_directory']}/plugins/#{base_name}"
    notifies :restart, "service[#{node['elasticsearch']['service']['name']}]"
  end
end