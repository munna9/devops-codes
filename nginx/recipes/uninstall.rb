service node['nginx']['service']['name'] do
  action [:disable, :stop]
end
directory node['nginx']['app']['base_directory'] do
  recursive true
  action :delete
end
node['nginx']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['nginx']['pin_version']
    action :remove
  end
end
