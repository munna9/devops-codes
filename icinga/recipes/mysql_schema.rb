node['icinga']['mysql_schema']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['icinga']['pin_version']
    action :install
  end
end
db_root_credentials=data_bag_item('credentials','db_root')
icinga_credentials=data_bag_item('credentials','icinga')

template "#{node['icinga']['schema']['mysql_base_directory']}/icinga_db.sql" do
  source 'sql/icinga_db.sql.erb'
  sensitive true
  variables(
    :schema_name => node['icinga']['schema']['name'],
    :db_username => icinga_credentials['db_username'],
    :db_password => icinga_credentials['db_password']
  )
  notifies :run, 'execute[icinga_db-creation]', :immediately
end
execute 'icinga_db-creation' do
  command "#{node['mysql']['binary']['path']} -u #{db_root_credentials['db_username']} < #{node['icinga']['schema']['mysql_base_directory']}/icinga_db.sql;
    #{node['mysql']['binary']['path']} -u #{db_root_credentials['db_username']} #{node['icinga']['schema']['name']} < #{node['icinga']['schema']['mysql_base_directory']}/mysql.sql"
  action :nothing
end

template "#{node['icinga']['schema']['mysql_base_directory']}/icingaweb_db.sql" do
  source 'sql/icingaweb_db.sql.erb'
  sensitive true
  variables(
    :schema_name      => node['icinga']['web']['schema_name'],
    :db_username      => icinga_credentials['db_username'],
    :db_password      => icinga_credentials['db_password']
  )
  notifies :run, 'execute[icingaweb_db-creation]', :immediately
end
execute 'icingaweb_db-creation' do
  command "#{node['mysql']['binary']['path']} -u #{db_root_credentials['db_username']} < #{node['icinga']['schema']['mysql_base_directory']}/icingaweb_db.sql"
  action :nothing
end

template "#{node['icinga']['schema']['mysql_base_directory']}/set_admin_password.sql" do
  source 'sql/set_admin_password.erb'
  sensitive true
  variables(
    :admin_username   => icinga_credentials['username'],
    :admin_password   => icinga_credentials['password']
  )
  notifies :run, 'execute[icingaweb-admin-password]' , :immediately
end
execute 'icingaweb-admin-password' do
  command "#{node['mysql']['binary']['path']} -u #{db_root_credentials['db_username']} #{node['icinga']['web']['schema_name']} < #{node['icinga']['schema']['mysql_base_directory']}/set_admin_password.sql"
  action :nothing
end

link "#{node['icinga']['conf']['base_directory']}/features-enabled/ido-mysql.conf" do
  to "#{node['icinga']['conf']['base_directory']}/features-available/ido-mysql.conf"
  notifies :restart, "service[#{node['icinga']['service']['name']}]"
end
