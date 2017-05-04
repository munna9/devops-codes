root_credentials=data_bag_item('credentials','db_root')
execute 'mysqld-safe-mode' do
  command  "#{Chef::Config['file_cache_path']}/mysql-init"
  action :nothing
end
template "#{Chef::Config['file_cache_path']}/mysql-init" do
  source 'mysql-init.erb'
  variables(
    :root_username => root_credentials['db_username'],
    :root_password => root_credentials['db_password']
  )
  mode '0700'
  sensitive true
  notifies :stop, "service[#{node['mysql']['service']['name']}]", :immediately
  notifies :run, 'execute[mysqld-safe-mode]', :immediately
  notifies :restart, "service[#{node['mysql']['service']['name']}]", :immediately

end
