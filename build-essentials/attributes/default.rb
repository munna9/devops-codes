default['build-essentials']['buildproperties_repo']['uri']='git@bitbucket.org:maheimom/buildproperties.git'
default['build-essentials']['buildproperties_repo']['checkout_directory']='buildproperties'
default['build-essentials']['buildproperties_repo']['branch']='develop'

default['build-essentials']['maven']['version']='3.5.0'
default['build-essentials']['maven']['binary_package']="apache-maven-#{node['build-essentials']['maven']['version']}-bin.tar.gz"
default['build-essentials']['maven']['uri'] = "http://redrockdigimark.com/apachemirror/maven/maven-3/#{node['build-essentials']['maven']['version']}/binaries/#{node['build-essentials']['maven']['binary_package']}"
default['build-essentials']['maven']['base_directory']='/usr/local'
default['build-essentials']['maven']['home_directory']="#{node['build-essentials']['maven']['base_directory']}/apache-maven-#{node['build-essentials']['maven']['version']}"
default['build-essentials']['maven']['app_directory']="#{node['build-essentials']['maven']['base_directory']}/apache-maven"
