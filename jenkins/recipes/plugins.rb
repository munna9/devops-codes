directory node['jenkins']['app']['plugin_directory'] do
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  recursive true
end
node['jenkins']['plugin']['packages'].each do |plugin_name,plugin_version|
  if node['jenkins']['plugin']['fetch_latest']
    remote_file "#{node['jenkins']['app']['plugin_directory']}/#{plugin_name}.hpi" do
      source "#{node['jenkins']['plugin']['latest_permalink']}/#{plugin_name}.hpi"
      owner node['jenkins']['service']['owner']
      group node['jenkins']['service']['group']
      mode '0644'
      sensitive true
      action :create
      notifies :restart, "service[#{node['jenkins']['service']['name']}]"
    end
  else
    remote_file "#{node['jenkins']['app']['plugin_directory']}/#{plugin_name}.hpi" do
      source "#{node['jenkins']['plugin']['uri']}/#{plugin_name}/#{plugin_version}/#{plugin_name}.hpi"
      owner node['jenkins']['service']['owner']
      group node['jenkins']['service']['group']
      mode '0644'
      sensitive true
      action :create
      notifies :restart, "service[#{node['jenkins']['service']['name']}]"
    end
  end
end