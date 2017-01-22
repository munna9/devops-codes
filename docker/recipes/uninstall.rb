execute 'clean-all-containers-n-images' do
  command "#{node['docker']['wrapper']['base_directory']}/docker-clean_all"
end
service node['docker']['service']['name'] do
  action [:disable, :stop]
end
node['docker']['binary']['packages'][node['platform']][node['platform_version']].each do |package_name,package_version|
  package package_name do
    version package_version if node['docker']['pin_versions']
    action :remove
  end
end
node['docker']['wrapper']['scripts'].each do |script_name|
  file "#{node['docker']['wrapper']['base_directory']}/#{script_name}" do
    action :delete
  end
end
file '/etc/profile.d/docker.sh' do
  action :delete
end
yum_repository 'dockerrepo' do
  action :remove
  only_if{ %w('centos', 'redhat').include?(node['platform']) }
end
apt_repository 'dockerrepo' do
  action :remove
  only_if { %w(ubuntu).include?(node['platform']) }
end
cron 'docker-clean' do
  action :delete
end