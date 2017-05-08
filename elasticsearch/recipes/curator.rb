
node['curator']['pip']['packages'].each do |pip_package,pip_version|
  execute "install-via-pip-#{pip_package}" do
    command "pip install --upgrade #{pip_package}==#{pip_version};touch #{Chef::Config['file_cache_path']}/.#{pip_package}-#{pip_version}.installed"
    creates "#{Chef::Config['file_cache_path']}/.#{pip_package}-#{pip_version}.installed"
  end
end


%w(curator).each do |binary_name|
  link "/usr/bin/#{binary_name}" do
    to "/usr/local/bin/#{binary_name}"
    only_if { ::File.exist? "/usr/local/bin/#{binary_name}" }
  end
end

directory node['curator']['conf']['home_directory'] do
  recursive true
end
template "#{node['curator']['conf']['home_directory']}/curator.yml" do
  source 'curator.yml.erb'
  sensitive true
end
node['curator']['indices'].each do |indices_name,each_operation|
  each_operation.each do |action,duration|
    template "#{node['curator']['conf']['home_directory']}/#{indices_name}_#{action}.yml" do
      source 'action.yml.erb'
      sensitive true
      variables(
        :operation_in_action => action,
        :beat_configuration => indices_name,
        :duration => duration
      )
    end
    cron "#{indices_name}-#{action}" do
      hour indices_name.length
      minute action.length
      command "/usr/bin/curator --config #{node['curator']['conf']['home_directory']}/curator.yml #{node['curator']['conf']['home_directory']}/#{indices_name}_#{action}.yml"
    end

  end
end
