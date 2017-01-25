node['nginx']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['nginx']['pin_version']
    action :install
  end
end

template "#{node['nginx']['app']['base_directory']}/nginx.conf" do
  source 'nginx.conf.erb'
  sensitive true
  notifies :restart, "service[#{node['nginx']['service']['name']}]"
end

%w(sites-available sites-enabled).each do |default_site|
  directory "#{node['nginx']['app']['base_directory']}/#{default_site}" do
    recursive true
    action :delete
    only_if { node['platform_family'] == 'debian' }
  end
end