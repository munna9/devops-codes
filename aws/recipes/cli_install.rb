node['aws']['cli']['packages'].each do |pip_package,pip_version|
  execute "install-via-pip-#{pip_package}" do
    command "pip install -q --upgrade #{pip_package}==#{pip_version};touch #{Chef::Config['file_cache_path']}/.#{pip_package}-#{pip_version}.installed"
    creates "#{Chef::Config['file_cache_path']}/.#{pip_package}-#{pip_version}.installed"
  end
end
%w(aws).each do |binary_name|
  link "/usr/bin/#{binary_name}" do
    to "/usr/local/bin/#{binary_name}"
    only_if { ::File.exist? "/usr/local/bin/#{binary_name}" }
  end
end
