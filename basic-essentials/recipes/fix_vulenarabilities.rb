node['vulnerabilities']['packages']['install'][node['platform']][node['platform_version']].each do |package_name,package_version|
   package "#{package_name}-#{package_version}" do
  	package_name package_name
    version package_version if node['vulnerabilities']['pin_version']
  end

end
node['vulnerabilities']['packages']['remove'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package "#{package_name}-#{package_version}" do
  	package_name package_name
    version package_version if node['vulnerabilities']['pin_version']
    action :remove
  end

end