default['oracle_java']['app']['base_directory']='/usr/local'
default['oracle_java']['app']['default_path']= '/usr/bin/java'

# JDK - 1.8.0_131
default['oracle_java']['default']['binary_version']='8u131'
default['oracle_java']['default']['binary_package']="jdk-#{node['oracle_java']['default']['binary_version']}-linux-x64.tar.gz"
default['oracle_java']['default']['uri']="http://download.oracle.com/otn-pub/java/jdk/#{node['oracle_java']['default']['binary_version']}-b11/d54c1d3a095b4ff2b6607d096fa80163/#{node['oracle_java']['default']['binary_package']}"

default['oracle_java']['default']['app_version']='1.8.0_131'
default['oracle_java']['default']['home_directory']="#{node['oracle_java']['app']['base_directory']}/jdk#{node['oracle_java']['default']['app_version']}"
default['oracle_java']['default']['binary_path']="#{node['oracle_java']['default']['home_directory']}/jre/bin/java"

###JDK - 1.8.0_45

default['oracle_java']['services']['binary_version']='8u45'
default['oracle_java']['services']['binary_package']="jdk-#{node['oracle_java']['services']['binary_version']}-linux-x64.tar.gz"
default['oracle_java']['services']['uri']="http://download.oracle.com/otn-pub/java/jdk/#{node['oracle_java']['services']['binary_version']}-b14/#{node['oracle_java']['services']['binary_package']}"

default['oracle_java']['services']['app_version']='1.8.0_45'
default['oracle_java']['services']['home_directory']="#{node['oracle_java']['app']['base_directory']}/jdk#{node['oracle_java']['services']['app_version']}"
default['oracle_java']['services']['binary_path']="#{node['oracle_java']['services']['home_directory']}/jre/bin/java"
