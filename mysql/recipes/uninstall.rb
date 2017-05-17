service node['mysql']['service']['name'] do
  action [:disable, :stop]
end

node['mysql']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['mysql']['pin_version']
    action :remove
  end
end