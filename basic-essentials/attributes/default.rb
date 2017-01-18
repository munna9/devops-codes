default['oracle_java']['app']['base_directory']='/usr/lib/jvm'
default['oracle_java']['app']['default_path']= '/usr/bin/java'

#Oracle Java - 8u111 - Default version

default['oracle_java']['default']['binary_version']='8u111'
default['oracle_java']['default']['binary_package']="jdk-#{node['oracle_java']['default']['binary_version']}-linux-x64.tar.gz"
default['oracle_java']['default']['uri']="http://download.oracle.com/otn-pub/java/jdk/#{node['oracle_java']['default']['binary_version']}-b14/#{node['oracle_java']['default']['binary_package']}"

default['oracle_java']['default']['app_version']='1.8.0_111'
default['oracle_java']['default']['home_directory']="#{node['oracle_java']['app']['base_directory']}/jdk#{node['oracle_java']['default']['app_version']}"
default['oracle_java']['default']['binary_path']="#{node['oracle_java']['default']['home_directory']}/jre/bin/java"


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

default['chefdk']['binary']['version']='1.1.16'
default['chefdk']['binary']['package'] = {
    'rhel' => "chefdk-#{node['chefdk']['binary']['version']}-1.el7.x86_64.rpm",
    'ubuntu' => "chefdk_#{node['chefdk']['binary']['version']}-1_amd64.deb"
}
default['chefdk']['download']['uri']= {
    'centos' => {
        '7.2.1511' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/el/7/#{node['chefdk']['binary']['package'][node['platform_family']]}"
    },
    'amazon' => {
        '2016.09' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/el/7/#{node['chefdk']['binary']['package'][node['platform_family']]}"
    },
    'ubuntu' => {
        '16.04' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/#{node['platform']}/#{node['platform_version']}/#{node['chefdk']['binary']['package'][node['platform_family']]}"
    }
}
case node['platform_version']
  when '7.2.1511', '7.3.1611', '2016.09'
    default['epel']['repo']['uri']='https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
end

