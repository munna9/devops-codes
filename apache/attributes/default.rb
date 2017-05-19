default['apache']['pin_version']=true
default['apache']['binary']['packages'] ={
    'amazon' => {
      '2017.03' => {
        'httpd'         => '2.2.31-1.8.amzn1'
    },
      '2016.09' => {
          'httpd'         => '2.2.31-1.8.amzn1'
      }
  },
  'centos' => {
    '7.3.1611' => {
      'httpd'         => '2.4.6-45.el7.centos'
    },
    '7.2.1511' => {
      'httpd'         => '2.4.6-45.el7.centos'
    }
  },
  'ubuntu' => {
    '16.04' => {
      'apache2'       => '2.4.18-2ubuntu3.2'
    },
    '14.04' => {
      'apache2'       => '2.4.7-1ubuntu4'
    }
  }
}
case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['apache']['conf']['home_directory']='/etc/httpd/conf.d'
    default['apache']['service']['name']='httpd'
    default['apache']['service']['owner']='apache'
    default['apache']['service']['group']='apache'
  when 'ubuntu'
    default['apache']['service']['name']='apache2'
    default['apache']['service']['owner']='www-data'
    default['apache']['service']['group']='www-data'

end
