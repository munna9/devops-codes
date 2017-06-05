default['icinga']['pin_version']=true

default['icinga']['repo']['name']='icinga'
default['icinga']['repo']['gpg_key'] ='http://packages.icinga.com/icinga.key'

case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['icinga']['repo']['base_uri']='http://packages.icinga.org/epel/7/release/'
    default['icinga']['web']['php_ini']='/etc/php.ini'
  when 'ubuntu'
    default['icinga']['repo']['base_uri']='http://packages.icinga.com/debian'
    default['icinga']['web']['php_ini']='/etc/php/7.0/apache2/php.ini'
end

default['icinga']['core']['packages'] ={
  'centos' => {
    '7.3.1611' => {
      'icinga2-common'                         => '2.6.3-1.el7.centos',
      'icinga2-libs'                           => '2.6.3-1.el7.centos',
      'icinga2-bin'                            => '2.6.3-1.el7.centos',
      'icinga2'                                => '2.6.3-1.el7.centos'
    },
    '7.2.1511' => {
      'icinga2-common'                         => '2.6.3-1.el7.centos',
      'icinga2-libs'                           => '2.6.3-1.el7.centos',
      'icinga2-bin'                            => '2.6.3-1.el7.centos',
      'icinga2'                                => '2.6.3-1.el7.centos',
    }
  },
  'ubuntu' => {
    '16.04' => {
      'icinga2-common'                        => '2.4.1-2ubuntu1',
      'icinga2-bin'                           => '2.4.1-2ubuntu1',
      'icinga2'                               => '2.4.1-2ubuntu1',
      'php7.0'                                => '7.0.15-0ubuntu0.16.04.4',
      'libapache2-mod-php7.0'                 => '7.0.15-0ubuntu0.16.04.4',
      'icingaweb2'                            => '2.1.0-1ubuntu1.2',
      'icinga2-ido-mysql'                     => '2.4.1-2ubuntu1',
      'nagios-plugins'                        => '2.1.2-2ubuntu2'
    }
  }
}

default['icinga']['plugin']['packages'] ={
  'centos' => {
    '7.3.1611' => {
      'nagios-plugins-all'                     => '2.1.4-2.el7',
    },
    '7.2.1511' => {
      'nagios-plugins-all'                     => '2.1.4-2.el7',
    }
  },
  'ubuntu' => {
    '16.04' => {
      'nagios-plugins'                        => '2.1.2-2ubuntu2'
    }
  }
}

default['icinga']['web2']['packages'] ={
  'centos' => {
    '7.3.1611' => {
      'icingaweb2'                             => '2.4.1-1.el7.centos',
      'icingaweb2-common'                      => '2.4.1-1.el7.centos',
      'php-ZendFramework'                      => '1.12.20-1.el7',
      'php-ZendFramework-Db-Adapter-Pdo'       => '1.12.20-1.el7',
      'php-ZendFramework-Db-Adapter-Pdo-Mysql' => '1.12.20-1.el7'
    },
    '7.2.1511' => {
      'icingaweb2'                             => '2.4.1-1.el7.centos',
      'icingaweb2-common'                      => '2.4.1-1.el7.centos',
      'php-ZendFramework'                      => '1.12.20-1.el7',
      'php-ZendFramework-Db-Adapter-Pdo'       => '1.12.20-1.el7',
      'php-ZendFramework-Db-Adapter-Pdo-Mysql' => '1.12.20-1.el7'
    }
  },
  'ubuntu' => {
    '16.04' => {
      'icinga2-common'                        => '2.4.1-2ubuntu1',
      'icinga2-bin'                           => '2.4.1-2ubuntu1',
      'icinga2'                               => '2.4.1-2ubuntu1',
      'php7.0'                                => '7.0.15-0ubuntu0.16.04.4',
      'libapache2-mod-php7.0'                 => '7.0.15-0ubuntu0.16.04.4',
      'icingaweb2'                            => '2.1.0-1ubuntu1.2',
      'icinga2-ido-mysql'                     => '2.4.1-2ubuntu1'
    }
  }
}

default['icinga']['service']['name']='icinga2'
default['icinga']['service']['owner']='icinga'
default['icinga']['service']['group']='icinga'

default['icinga']['schema']['name']='icinga'
default['icinga']['schema']['mysql_base_directory']='/usr/share/icinga2-ido-mysql/schema'
default['icinga']['mysql_schema']['packages'] ={
  'centos' => {
    '7.3.1611' => {
      'icinga2-ido-mysql'         => '2.6.3-1.el7.centos',
    },
    '7.2.1511' => {
      'icinga2-ido-mysql'         => '2.6.3-1.el7.centos',
    }
  },
  'ubuntu' => {
    '16.04' => {
    'icinga2-ido-mysql'            => '2.4.1-2ubuntu1',
    }
  }
}
default['icinga']['api']['listner_port']='5665'
default['icinga']['web']['schema_name']='icingaweb2'
default['icinga']['web']['base_directory']='/etc/icingaweb2'
default['icinga']['web']['owner']='icingaweb2'
default['icinga']['web']['group']='icingaweb2'
default['icinga']['web']['modules_base_directory']='/usr/share/icingaweb2/modules'
default['icinga']['web']['monitoring_directory']="#{node['icinga']['web']['base_directory']}/modules/monitoring"
default['icinga']['conf']['base_directory'] = '/etc/icinga2'
default['icinga']['conf']['home_directory']="#{node['icinga']['conf']['base_directory']}/conf.d"

default['icinga']['ssl']['base_directory']="/var/lib/icinga2"
default['icinga']['ssl']['home_directory']="#{node['icinga']['conf']['base_directory']}/pki"

default['icinga']['plugin']['home_directory']='/usr/lib64/nagios/plugins'

default['icinga']['conf']['chef_obj_directory']="#{node['icinga']['conf']['home_directory']}/chef-objects"

