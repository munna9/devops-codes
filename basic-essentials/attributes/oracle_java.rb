default['oracle_java']['app']['base_directory']='/usr/lib/jvm'
default['oracle_java']['app']['default_path']= '/usr/bin/java'

default['oracle_java']['default']['binary_version']='8u111'
default['oracle_java']['default']['binary_package']="jdk-#{node['oracle_java']['default']['binary_version']}-linux-x64.tar.gz"
default['oracle_java']['default']['uri']="http://download.oracle.com/otn-pub/java/jdk/#{node['oracle_java']['default']['binary_version']}-b14/#{node['oracle_java']['default']['binary_package']}"

default['oracle_java']['default']['app_version']='1.8.0_111'
default['oracle_java']['default']['home_directory']="#{node['oracle_java']['app']['base_directory']}/jdk#{node['oracle_java']['default']['app_version']}"
default['oracle_java']['default']['binary_path']="#{node['oracle_java']['default']['home_directory']}/jre/bin/java"
