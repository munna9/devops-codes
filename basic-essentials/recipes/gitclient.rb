node['gitclient']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['gitclient']['pin_versions']
    action :install
  end
end
