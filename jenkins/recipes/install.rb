yum_repository 'jenkins' do
  description 'Jenkins stable repo'
  baseurl node['jenkins']['install']['uri']
  gpgcheck true
  gpgkey node['jenkins']['install']['key']
  action :create
  only_if { node['platform_family'] == 'rhel'}
end
apt_repository  'jenkins' do
  uri node['jenkins']['install']['uri']
  distribution 'binary/'
  key node['jenkins']['install']['key']
  action :add
  only_if { node['platform_family'] == 'debian'}
end
node['jenkins']['binary']['packages'][node['platform']].each do |package_name,package_version|
  package package_name do
    version package_version if node['jenkins']['pin_version']
    action :install
    notifies :restart, "service[#{node['jenkins']['service']['name']}]"
  end
end

file 'skip_unlock_edition' do
  path "#{node['jenkins']['app']['home_directory']}/jenkins.install.InstallUtil.lastExecVersion"
  content'2.0'
  mode '0755'
  owner node['jenkins']['service']['owner']
  group node['jenkins']['service']['group']
  sensitive true
  action :create
end

