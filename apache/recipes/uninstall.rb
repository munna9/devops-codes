service node['apache']['service']['name'] do
  action [:disable, :stop]
end

node['apache']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['apache']['pin_version']
    action :remove
  end
end