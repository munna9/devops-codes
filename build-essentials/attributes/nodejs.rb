case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['nodejs']['repo']['uri']='https://rpm.nodesource.com/setup_7.x'
  when 'ubuntu', 'debian'
    default['nodejs']['repo']['uri']='https://deb.nodesource.com/setup_7.x'
end
default['nodejs']['binary']['package']='nodejs'
default['nodejs']['binary']['version']='7.10.0'

default['nodejs']['gulp']['binary_path']='/usr/bin/gulp'
default['nodejs']['ng']['binary_path']='/usr/bin/ng'