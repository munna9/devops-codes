if node['os'] == 'linux'
  remote_file "#{Chef::Config['file_cache_path']}/#{node['build-essentials']['maven']['binary_package']}" do
    source node['build-essentials']['maven']['uri']
    sensitive true
  end
  bash 'extract-maven-binary' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar xzf #{node['build-essentials']['maven']['binary_package']} -C #{node['build-essentials']['maven']['base_directory']}
    EOH
    action :run
    not_if { ::File.exist?(node['build-essentials']['maven']['home_directory'])}
  end
  link node['build-essentials']['maven']['app_directory'] do
    to node['build-essentials']['maven']['home_directory']
  end
end