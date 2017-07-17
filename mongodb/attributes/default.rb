default['mongodb']['major']['version']='3.2'

default['mongodb']['pin_version']=true

case node['platform']
  when 'centos', 'redhat', 'scientific', 'oracle'
    default['mongodb']['download']['uri']="https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/#{node['mongodb']['major']['version']}/$basearch/"
  when 'amazon'
    default['mongodb']['download']['uri']="https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/#{node['mongodb']['major']['version']}/x86_64/"
end

default['mongodb']['binary']['packages'] = {
  '3.4' => {
    'centos' => {
      'mongodb-org'           => '3.4.4-1.el7',
      'mongodb-org-tools'     => '3.4.4-1.el7',
      'mongodb-org-shell'     => '3.4.4-1.el7',
      'mongodb-org-server'    => '3.4.4-1.el7',
      'mongodb-org-mongos'    => '3.4.4-1.el7',
    },
    'amazon' => {
      'mongodb-org'           => '3.4.4-1.amzn1',
      'mongodb-org-tools'     => '3.4.4-1.amzn1',
      'mongodb-org-shell'     => '3.4.4-1.amzn1',
      'mongodb-org-server'    => '3.4.4-1.amzn1',
      'mongodb-org-mongos'    => '3.4.4-1.amzn1',
    }
  },
  '3.2' => {
    'centos' => {
      'mongodb-org'           => '3.2.12-1.el7',
      'mongodb-org-tools'     => '3.2.12-1.el7',
      'mongodb-org-shell'     => '3.2.12-1.el7',
      'mongodb-org-server'    => '3.2.12-1.el7',
      'mongodb-org-mongos'    => '3.2.12-1.el7'
    },
    'amazon' => {
      'mongodb-org'           => '3.2.4-1.amzn1',
      'mongodb-org-tools'     => '3.2.4-1.amzn1',
      'mongodb-org-shell'     => '3.2.4-1.amzn1',
      'mongodb-org-server'    => '3.2.4-1.amzn1',
      'mongodb-org-mongos'    => '3.2.4-1.amzn1'
    }
  }
}
default['mongodb']['service']['name']='mongod'
default['mongodb']['service']['owner']='mongod'
default['mongodb']['service']['group']='mongod'
default['mongodb']['service']['port']='27017'

default['mongodb']['log']['base_directory']='/var/log/mongodb'
default['mongodb']['log']['file']="#{node['mongodb']['log']['base_directory']}/mongod.log"
default['mongodb']['storage']['base_directory']='/MongoVolume'
default['mongodb']['storage']['path']="#{node['mongodb']['storage']['base_directory']}/mongodb"
default['mongodb']['conf']['file']='/etc/mongod.conf'
default['mongodb']['service']['lock_file']="#{node['mongodb']['storage']['path']}/mongod.lock"
default['mongodb']['logfile']['retension']='90'

default['mongodb']['app']['base_directory']='/var/lib/mongo'
default['mongodb']['app']['key_file']="#{node['mongodb']['app']['base_directory']}/mongodb-keyfile"

default['mongodb']['binary']['path']='/usr/bin/mongo'
default['mongodb']['sysctl']['home_directory']='/etc/sysctl.d'
default['mongodb']['sysctl']['conf']="#{node['mongodb']['sysctl']['home_directory']}/01-mongod.conf"

default['mongodb']['sysctl']['options'] ={
  'vm.swappiness' => '10',
  'net.ipv4.tcp_keepalive_time' => '300'
}