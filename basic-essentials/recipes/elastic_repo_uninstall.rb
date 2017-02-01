yum_repository node['elastic']['repo']['name'] do
  action :remove
  only_if { %w(centos redhat amazon scientific oracle).include?(node['platform']) }
end
if node['platform'] == 'ubuntu'
  node['elastic']['repo']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
    package package_name do
      version package_version
      action :remove
    end
  end
  apt_repository node['elastic']['repo']['name'] do
    action :remove
  end
end
