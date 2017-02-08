git "#{node['jenkins']['app']['home_directory']}/jenkins_backup" do
  repository node['jenkins']['conf']['uri']
  user node['jenkins']['service']['owner']
  action :sync
  notifies :run, 'bash[restore-configurations]', :immediately
end
bash 'restore-configurations' do
  cwd "#{node['jenkins']['app']['home_directory']}/jenkins_backup"
  code <<-EOH
  rsync -avz * "#{node['jenkins']['app']['home_directory']}"
  EOH
  action :nothing
  notifies :restart, "service[#{node['jenkins']['service']['name']}]"
end
directory node['jenkins']['app']['home_directory'] do
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  recursive true
end

