default['icinga']['pnp4nagios']['packages']={
  'centos' => {
    '7.3.1611' => {
      'pnp4nagios'      => '0.6.25-1.el7',
      'icinga-web-module-pnp'  => '1.14.0-1.el7.centos'

    },
    '7.2.1511' => {
      'pnp4nagios'             => '0.6.25-1.el7',
      'icinga-web-module-pnp'  => '1.14.0-1.el7.centos'

    }
  },
  'ubuntu' => {
    '16.04' => {
      'pnp4nagios'      => '0.6.25-1.el7'
    }
  }
}
default['icinga']['pnp4nagios']['spooldir']='/var/spool/icinga2/perfdata'
default['icinga']['pnp4nagios']['conf_directory']='/etc/pnp4nagios'
default['icinga']['pnp4nagios']['service']='npcd'
default['icinga']['pnp4nagios']['ic2module_uri']='https://github.com/Icinga/icingaweb2-module-pnp.git'
default['icinga']['pnp4nagios']['ic2module']="#{node['icinga']['web']['modules_home_directory']}/pnp"
default['icinga']['nagios']['html_directory']="/usr/share/nagios/html"
default['icinga']['nagios']['cgi_directory']="/usr/lib64/nagios/cgi-bin/"
default['icinga']['pnp4nagios']['html_directory']="#{node['icinga']['nagios']['html_directory']}/pnp4nagios"
