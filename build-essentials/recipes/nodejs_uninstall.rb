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