yum_repository node['elastic']['repo']['name'] do
  description 'Elastic repository for 5.x packages'
  baseurl node['elastic']['repo']['base_uri']
  enabled true
  gpgcheck true
  gpgkey node['elastic']['repo']['gpg_key']
  action :add
  only_if { %w(centos redhat amazon scientific oracle).include?(node['platform']) }
end
if node['platform'] == 'ubuntu'
  node['elastic']['repo']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
    package package_name do
      version package_version
      action :install
    end
  end
  apt_repository node['elastic']['repo']['name'] do
    uri node['elastic']['repo']['base_uri']
    key node['elastic']['repo']['gpg_key']
    distribution ''
    components ['stable', 'main']
  end
end
