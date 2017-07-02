#Git Client
default['gitclient']['pin_version']=true
default['gitclient']['binary']['packages'] = {
  'amazon' => {
    '2017.03' => { 
      'git'       => '2.7.5-1.49',
      'perl-Git'  =>  '2.7.5-1.49'
    },
    '2016.09' => {
      'git'       =>  '2.7.5-1.49.amzn1',
      'perl-Git'  =>  '2.7.5-1.49.amzn1'
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

default['pip']['repo']['uri']='https://bootstrap.pypa.io/get-pip.py'
