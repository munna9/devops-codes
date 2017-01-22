unless node['platform'] == 'amazon'
  yum_repository 'dockerrepo' do
    description 'Docker repository'
    baseurl node['docker']['repo']['base_uri']
    enabled true
    gpgcheck true
    gpgkey node['docker']['repo']['gpg_key']
    action :add
    only_if { %w(centos redhat).include?(node['platform']) }
  end
  apt_repository 'dockerrepo' do
    uri node['docker']['repo']['base_uri']
    distribution "#{node['platform']}-#{node['lsb']['codename']}"
    keyserver node['docker']['repo']['gpg_key']
    key node['docker']['repo']['key_id']
    components ['main']
    action :add
    only_if { %w(ubuntu).include?(node['platform']) }
  end
end
node['docker']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['docker']['pin_version']
    action :install
  end
end