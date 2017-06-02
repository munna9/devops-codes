node['apache']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['apache']['pin_version']
    action :install
  end
end