%w(gulp-cli ng-cli angular-cli).each do |each_command|
  execute "Uninstall - #{each_command}" do
    command "npm uninstall --global #{each_command}"
  end
end

execute 'Gulp-uninstall' do
  command 'npm uninstall --global gulp-cli'
end
execute 'NG-uninstall' do
  command 'npm uninstall --global ng-cli'
end
package node['nodejs']['binary']['package'] do
  version node['nodejs']['binary']['version'] if node['nodejs']['pin_version']
  action :remove
end
file "#{Chef::Config['file_cache_path']}/setup.sh" do
  action :delete
end
directory node['nodejs']['nvm']['home_directory'] do
  action :delete
end
file '/etc/profile.d/nvm.sh' do
  action :delete
end
file "#{Chef::Config['file_cache_path']}/nvm_install.sh" do
  action :delete
end
