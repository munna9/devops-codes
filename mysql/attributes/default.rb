default['mysql']['pin_version']=true
default['mysql']['binary']['packages'] = {
  'amazon' => {
    '2017.03' => {
      'mysql-server'        => '5.5-1.6.amzn1',
      'mysql'               => '5.5-1.6.amzn1'
    },
    '2016.09' => {
      'mysql-server'       => '5.5-1.6.amzn1',
      'mysql'              => '5.5-1.6.amzn1'
    }
  },
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
      'mysql-server'        => '5.7.18-0ubuntu0.16.04.1',
      'mysql-client'        => '5.7.18-0ubuntu0.16.04.1',
    },
    '14.04' => {
      'mysql-server'        => '5.5.55-0ubuntu0.14.04.1',
      'mysql-client'        => '5.5.55-0ubuntu0.14.04.1',
    }
  }
}

case node['platform']
  when 'centos', 'redhat', 'scientific', 'oracle'
    default['mysql']['service']['name']='mariadb'
  when 'ubuntu'
    default['mysql']['service']['name']='mysql'
  when 'amazon'
    default['mysql']['service']['name']='mysqld'
end
