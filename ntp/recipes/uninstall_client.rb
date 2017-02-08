service node['ntp']['service']['name'] do
  action [:disable, :stop]
end

node['ntp']['client']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['ntp']['pin_version']
    action :remove
  end
end
