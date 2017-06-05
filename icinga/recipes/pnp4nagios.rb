node['icinga']['pnp4nagios']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['icinga']['pin_version']
    action :install
  end
end

link "/etc/icinga2/features-enabled/perfdata.conf" do
  to "/etc/icinga2/features-available/perfdata.conf"
  notifies :restart, "service[#{node['icinga']['service']['name']}]"
end

service node['icinga']['pnp4nagios']['service'] do
  supports [:start, :stop, :reload, :enable, :disable]
  action [:enable, :start]
end
git node['icinga']['pnp4nagios']['ic2module'] do
  repository node['icinga']['pnp4nagios']['ic2module_uri']
  action :checkout
  notifies :run, "ruby_block[confg-php]"
end
link "#{node['icinga']['web']['base_directory']}/enabledModules/pnp" do
  to "#{node['icinga']['web_modules']['home_directory']}/pnp"

  notifies :restart, "service[#{node['icinga']['service']['name']}]"
  notifies :restart, "service[#{node['apache']['service']['name']}]"
end
ruby_block "confg-php" do
  block do
    file = Chef::Util::FileEdit.new("#{node['icinga']['pnp4nagios']['conf_directory']}/config.php")
    file.search_file_replace_line("$conf['nagios_base'] = \"/nagios/cgi-bin\";", "'$conf['nagios_base'] = \"/icinga/cgi-bin\";")
    file.write_file
  end
  action :nothing
end
template "#{node['icinga']['pnp4nagios']['conf_directory']}/npcd.cfg" do
  source 'pnp4nagios/npcd.cfg.erb'
  sensitive true
  notifies :restart, "service[#{node['icinga']['pnp4nagios']['service']}]"
end
directory '/var/lib/pnp4nagios' do
  owner node['icinga']['service']['owner']
  group node['icinga']['service']['group']
end

%w(nagios.conf pnp4nagios.conf).each do |file_name|
  template "#{node['apache']['conf']['home_directory']}/#{file_name}" do
    source "pnp4nagios/#{file_name}.erb"
    sensitive true
    notifies :reload, "service[#{node['apache']['service']['name']}]"
  end
end