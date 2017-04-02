node['aws']['cli']['packages'].each do |pip_package,pip_version|
  execute "install-via-pip-#{pip_package}" do
    command "pip uninstall -q #{pip_package}==#{pip_version};rm -rf #{Chef::Config['file_cache_path']}/.#{pip_package}.installed; touch #{Chef::Config['file_cache_path']}/.#{pip_package}.uninstalled"
    creates "#{Chef::Config['file_cache_path']}/.#{pip_package}.uninstalled"
  end
end
%w(aws).each do |binary_name|
  link "/usr/local/bin/#{binary_name}" do
    action :delete
    only_if { ::File.exist? "/usr/local/bin/#{binary_name}" }
  end
end
