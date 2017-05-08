node['elastalert']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['elastalert']['pin_version']
    action :install
  end
end
git node['elastalert']['app']['app_directory'] do
  repository node['elastalert']['repo']['uri']
  checkout_branch node['elastalert']['repo']['branch']
  action :sync
  notifies :run, "execute[install-elastalert]", :immediately
end
%w(base_directory conf_directory rules_directory).each do |directory_name|
  directory node['elastalert']['app'][directory_name] do
    recursive true
  end
end
execute 'install-elastalert' do
  cwd node['elastalert']['app']['app_directory']
  command "/usr/bin/env python setup.py install"
  action :nothing
end
node['elastalert']['pip']['packages'].each do |pip_package,pip_version|
  execute "install-via-pip-#{pip_package}" do
    command "pip install --upgrade #{pip_package}==#{pip_version};touch #{Chef::Config['file_cache_path']}/.#{pip_package}-#{pip_version}.installed"
    creates "#{Chef::Config['file_cache_path']}/.#{pip_package}-#{pip_version}.installed"
  end
end

template "#{node['elastalert']['app']['conf_directory']}/config.yml" do
  source 'config.yml.erb'
  notifies :restart, "service[#{node['elastalert']['service']['name']}]"
end

node['elastalert']['alerts'].each do |alert_name|
  template "#{node['elastalert']['app']['rules_directory']}/#{alert_name}.yml" do
    source "rules/#{alert_name}.yml.erb"
    notifies :restart, "service[#{node['elastalert']['service']['name']}]"
  end
end