service node['mongodb']['service']['name'] do
  action [:disable, :stop]
end
[node['mongodb']['app']['key_file'],node['mongodb']['conf']['file'],"/etc/security/limits.d/#{node['mongodb']['service']['owner']}.conf", \
 node['mongodb']['sysctl']['conf'], '/etc/yum.repos.d/mongdb-org.conf'].each do |file_name|
  file file_name do
    action :remove
    ignore_failure :true
  end
end

[node['mongodb']['storage']['path']].each do |directory_name|
  directory directory_name do
    action :remove
    ignore_failure :true
  end
end

node['mongodb']['binary']['packages'][node['mongodb']['major']['version']][node['platform']].each do |package_name,package_version|
  package package_name do
    version package_version if node['mongodb']['pin_version']
    action :remove
  end
end