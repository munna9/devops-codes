default['nginx']['pin_version']=true
default['nginx']['binary']['packages'] = {
  'amazon' => {
    '2017.03' => {
      'nginx' => '1.10.2-1.30.amzn1'
    },
    '2016.09' => {
      'nginx' => '1.10.1-1.28.amzn1'
    }
  },
  'centos' => {
    '7.3.1611' => {
      'nginx' => '1.10.2-1.el7'
    },
    '7.2.1511' => {
      'nginx' => '1.10.2-1.el7'
    }
  },
  'ubuntu' => {
    '16.04' => {
      'nginx' => '1.10.0-0ubuntu0.16.04.4'
    },
    '14.04' => {
      'nginx' => '1.4.6-1ubuntu3.7'
    }
  }
}

case node['platform_family']
  when 'debian'
    default['nginx']['service']['name']='nginx'
    default['nginx']['service']['owner']='www-data'
    default['nginx']['service']['group']='www-data'
  when 'rhel'
    default['nginx']['service']['name']='nginx'
    default['nginx']['service']['owner']='nginx'
    default['nginx']['service']['group']='nginx'
end

default['nginx']['app']['base_directory']='/etc/nginx'
default['nginx']['app']['conf_directory']="#{node['nginx']['app']['base_directory']}/conf.d"
default['nginx']['app']['log_directory']='/var/log/nginx'
default['nginx']['site']['base_directory']='/usr/share/nginx'
default['nginx']['site']['default_directory']="#{node['nginx']['site']['base_directory']}/html"

default['nginx']['ssl']['base_directory']="#{node['nginx']['app']['base_directory']}/ssl"

default['nginx']['conf']['ajp_connect_timeout']=3600
default['nginx']['conf']['ajp_read_timeout']=3600
default['nginx']['conf']['ajp_send_timeout']=3600

default['nginx']['conf']['proxy_connect_timeout']=3600
default['nginx']['conf']['proxy_read_timeout']=3600
default['nginx']['conf']['proxy_send_timeout']=3600

default['nginx']['conf']['send_timeout']=10
