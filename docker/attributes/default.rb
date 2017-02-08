default['docker']['pin_version']=true

case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    case node['platform_version']
      when '7.2.1511', '7.3.1611'
        default['docker']['repo']['base_uri']='https://yum.dockerproject.org/repo/main/centos/7/'
        default['docker']['repo']['gpg_key']='https://yum.dockerproject.org/gpg'
    end
  when 'ubuntu'
    default['docker']['repo']['base_uri']='https://apt.dockerproject.org/repo'
    default['docker']['repo']['gpg_key']='hkp://ha.pool.sks-keyservers.net:80'
    default['docker']['repo']['key_id']='58118E89F3A912897C070ADBF76221572C52609D'
end

default['docker']['binary']['packages']= {
    'centos' => {
      '7.3.1611' => {
        'docker-engine' => '1.13.0-1.el7.centos'
      },
      '7.2.1511' => {
        'docker-engine' => '1.12.5-1.el7.centos'
      }
    },
    'amazon' => {
      '2016.09' => {
        'docker' => '1.12.6-1.17.amzn1'
      }
    },
    'ubuntu' => {
      '14.04' => {
        'docker-engine' => '1.13.0-0~ubuntu-trusty'
      }
    }
}



default['docker']['service']['name']='docker'
default['docker']['service']['owner']='root'
default['docker']['service']['group']='docker'

default['docker']['wrapper']['base_directory']='/usr/local/sbin'
default['docker']['wrapper']['scripts']=%w(docker-access docker-clean docker-clean_all docker-destroy docker-flush docker-flush_all)