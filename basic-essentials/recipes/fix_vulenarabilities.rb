node['vulnerabilities']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['vulnerabilities']['pin_version']
    action :upgrade
  end

end