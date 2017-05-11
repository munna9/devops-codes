case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['nodejs']['repo']['uri']='https://rpm.nodesource.com/setup_7.x'
  when 'ubuntu', 'debian'
    default['nodejs']['repo']['uri']='https://deb.nodesource.com/setup_7.x'
end
default['nodejs']['binary']['package']='nodejs'
default['nodejs']['binary']['version']='6.0.0'

default['nodejs']['gulp']['binary_path']='/usr/bin/gulp'
default['nodejs']['ng']['binary_path']='/usr/bin/ng'

default['nodejs']['nvm']['home_directory']='/usr/local/nvm'
default['nodejs']['nvm']['uri']='https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh'
default['nodejs']['nvm']['binary_path']="#{node['nodejs']['nvm']['home_directory']}/nvm.sh"
default['nodejs']['node']['versions']=%w(4.5.0)
default['nodejs']['angular']['cli']='angular-cli'
default['nodejs']['angular']['binary_path']='/usr/lib/node_modules/angular-cli/bin'
default['nodejs']['angular']['version']='1.0.0-beta.25.5'