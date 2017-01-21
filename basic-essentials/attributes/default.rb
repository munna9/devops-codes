#Git Client
default['gitclient']['pin_version']=true
default['gitclient']['binary']['packages'] = {
  'amazon' => {
    '2016.09' => {
      'git' => '2.7.4-1.47.amzn1'
    }
  },
  'centos' => {
    '7.2.1511' => {
      'git' => '1.8.3.1-6.el7_2.1'
    },
    '7.3.1611' => {
      'git' => '1.8.3.1-6.el7_2.1'
    }
  },
  'ubuntu' => {
    '14.04' => {
      'git' => '1.9.1-1ubuntu0.3'
    },
    '16.04' => {
      'git' => '1.9.1-1ubuntu0.3'
    }
  }
}

#EPEL repo
case node['platform_version']
  when '7.2.1511', '7.3.1611', '2016.09'
    default['epel']['repo']['uri']='https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
end

