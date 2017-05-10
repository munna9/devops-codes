remote_file "#{Chef::Config['file_cache_path']}/setup.sh" do
  source node['nodejs']['repo']['uri']
  sensitive true
  mode '0777'
  notifies :run, "execute[install-nodejs-repo]", :immediately
end
execute "install-nodejs-repo" do
  command "#{Chef::Config['file_cache_path']}/setup.sh"
  action :nothing
end
package node['nodejs']['binary']['package'] do
  version node['nodejs']['binary']['version'] if node['nodejs']['pin_version']
end
execute 'install-gulp-cli' do
  command "npm install --global gulp-cli"
  creates node['nodejs']['gulp']['binary_path']
end
execute 'install-ng-cli' do
  command "npm install --global ng-cli"
  creates node['nodejs']['ng']['binary_path']
end