node['gitclient']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name|
  package package_name do
    action :remove
  end
end