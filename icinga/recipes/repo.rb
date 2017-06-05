yum_repository node['icinga']['repo']['name'] do
  description 'Icinga Repostiory'
  baseurl node['icinga']['repo']['base_uri']
  enabled true
  gpgcheck true
  gpgkey node['icinga']['repo']['gpg_key']
  only_if { %w(centos redhat amazon scientific oracle).include?(node['platform']) }
end
apt_repository node['icinga']['repo']['name'] do
  uri node['icinga']['repo']['base_uri']
  key node['icinga']['repo']['gpg_key']
  components ['icinga-xenial', 'main']
  only_if { node['platform'] == 'ubuntu'}
end