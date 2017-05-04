default['mysql']['pin_version']=true
default['mysql']['binary']['packages'] = {
  'centos' => {
    '7.3.1611' => {
      'mariadb-server'      => '5.5.52-1.el7',
      'mariadb'             => '5.5.52-1.el7',
    },
    '7.2.1511' => {
      'mariadb-server'      => '5.5.52-1.el7',
      'mariadb'             => '5.5.52-1.el7',
    }
  },
  'ubuntu' => {
    '16.04' => {
      'mysql-server'        => '5.7.17-0ubuntu0.16.04.1',
      'mysql-client'        => '5.7.17-0ubuntu0.16.04.1',
    },
    '14.04' => {
      'mysql-server'        => '5.5.54-0ubuntu0.14.04.1',
      'mysql-client'        => '5.5.54-0ubuntu0.14.04.1',
    }
  }
}

case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['mysql']['service']['name']='mariadb'
  when 'ubuntu'
    default['mysql']['service']['name']='mysql'
end
default['mysql']['binary']['path']='/usr/bin/mysql'