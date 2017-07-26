default['phenomtrackapi']['maxmind_repo']['uri'] = 'git@bitbucket.org:maheimom/maxmind_dbs.git'
default['phenomtrackapi']['maxmind_repo']['checkout_directory'] = 'maxmind'
default['phenomtrackapi']['maxmind_repo']['branch'] = 'master'

default['phenomtrackapi']['app']['base_directory']='phenomtrack'
default['phenomtrackapi']['conf']['base_directory']="#{node['phenomtrackapi']['app']['base_directory']}/conf"
default['phenomtrackapi']['conf']['file']="#{node['phenomtrackapi']['conf']['base_directory']}/config.json"
default['phenomtrackapi']['service']['port']=8080

default['phenomtrackapi']['file']['MaxBackupIndex']=10
