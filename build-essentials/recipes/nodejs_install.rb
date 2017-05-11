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

remote_file "#{Chef::Config['file_cache_path']}/nvm_install.sh" do
  source node['nodejs']['nvm']['uri']
  sensitive true
  mode '0777'
end
directory node['nodejs']['nvm']['home_directory']
execute 'install-nvm' do
  command "export NVM_DIR=#{node['nodejs']['nvm']['home_directory']};bash #{Chef::Config['file_cache_path']}/nvm_install.sh"
  creates node['nodejs']['nvm']['binary_path']
end
template '/etc/profile.d/nvm.sh' do
  source 'nvm.sh.erb'
  sensitive true
  mode '0777'
end
node['nodejs']['node']['versions'].each do |node_version|
  bash "install-node-v#{node_version}" do
    code <<-EOH
      source #{node['nodejs']['nvm']['binary_path']}
      nvm install #{node_version}
    EOH
    creates "#{node['nodejs']['nvm']['home_directory']}/versions/node/v#{node_version}"
  end
end
bash 'install-angular-cli' do
  code <<-EOH
    nvm use 6.0.0
    npm install --global #{node['nodejs']['angular']['cli']}@#{node['nodejs']['angular']['version']}
  EOH
  creates node['nodejs']['angular']['binary_path']
end