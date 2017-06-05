node['icinga']['web2']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['icinga']['pin_version']
    action :install
  end
end
icinga_credentials=data_bag_item('credentials','icinga')

%w(config.ini resources.ini authentication.ini roles.ini groups.ini).each do |conf_file|
  template "#{node['icinga']['web']['base_directory']}/#{conf_file}" do
    source "icingaweb/#{conf_file}.erb"
    sensitive true
    owner node['apache']['service']['owner']
    group node['icinga']['web']['group']
    variables(
      :web_schema_name    => node['icinga']['web']['schema_name'],
      :app_schema_name    => node['icinga']['schema']['name'],
      :web_db_username    => icinga_credentials['db_username'],
      :web_db_password    => icinga_credentials['db_password'],
      :app_db_username    => icinga_credentials['db_username'],
      :app_db_password    => icinga_credentials['db_password'],
      :admin_username     => icinga_credentials['username'],
      :admin_password     => icinga_credentials['password']
    )
    notifies :restart, "service[#{node['icinga']['service']['name']}]"
    notifies :restart, "service[#{node['apache']['service']['name']}]"
  end
end
["#{node['icinga']['web']['base_directory']}/enabledModules" , node['icinga']['web']['monitoring_directory']].each do |directory_name|
  directory  directory_name do
    recursive true
    owner node['apache']['service']['owner']
    group node['icinga']['web']['group']
    action :create
  end
end
%w(setup monitoring).each do |module_name|
  link "#{node['icinga']['web']['base_directory']}/enabledModules/#{module_name}" do
    to "#{node['icinga']['web']['modules_base_directory']}/#{module_name}"
    notifies :restart, "service[#{node['icinga']['service']['name']}]"
    notifies :restart, "service[#{node['apache']['service']['name']}]"
  end
end
file '/usr/bin/ping' do
  mode '4755'
  notifies :run, 'ruby_block[php_ini]', :immediately
end
ruby_block "php_ini" do
  block do
    file = Chef::Util::FileEdit.new("#{node['icinga']['web']['php_ini']}")
    file.insert_line_if_no_match("/date.timezone/", "date.timezone=#{node['phenom']['timezone']}")
    file.write_file
  end
  action :nothing
end
%w(backends.ini commandtransports.ini config.ini).each do |conf_file|
  cookbook_file "#{node['icinga']['web']['monitoring_directory']}/#{conf_file}" do
    source "monitoring/#{conf_file}"
    sensitive true
    owner node['apache']['service']['owner']
    group node['icinga']['web']['group']
    notifies :restart, "service[#{node['icinga']['service']['name']}]"
    notifies :restart, "service[#{node['apache']['service']['name']}]"
  end
end
%w(checker command livestatus mainlog notification statusdata).each do |command_line|
  link "#{node['icinga']['conf']['base_directory']}/features-enabled/#{command_line}.conf" do
    to "#{node['icinga']['conf']['base_directory']}/features-available/#{command_line}.conf"
    notifies :restart, "service[#{node['icinga']['service']['name']}]"
  end
end