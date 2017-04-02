if node['os'] == 'linux'
  directory node['oracle_java']['app']['base_directory'] do
    recursive true
  end
  remote_file 'services-oracle-java-download' do
    path "#{Chef::Config[:file_cache_path]}/#{node['oracle_java']['services']['binary_package']}"
    source node['oracle_java']['services']['uri']
    headers({'Cookie' => 'oraclelicense=accept-securebackup-cookie'})
  end
  bash 'services-oracle-java-install' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar xzf #{node['oracle_java']['services']['binary_package']} -C #{node['oracle_java']['app']['base_directory']}
    EOH
    action :run
    not_if { ::File.exist?(node['oracle_java']['services']['home_directory'])}
  end
  link node['oracle_java']['app']['default_path'] do
    to '/etc/alternatives/java'
  end
  link '/etc/alternatives/java' do
    to node['oracle_java']['services']['binary_path']
  end
end