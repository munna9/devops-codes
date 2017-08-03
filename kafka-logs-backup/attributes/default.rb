default['kafka-logs-backup']['logs']['directory']="/var/log/kafka_logs_backup"
default['kafka-logs-backup']['config_repo']['uri'] = 'git@bitbucket.org:maheimom/kafka-logs-config.git'
default['kafka-logs-backup']['config_repo']['checkout_directory'] = 'kafka-logs-config'
default['kafka-logs-backup']['retension']['period']=7
default['kafka-logs-backup']['cleanup']['script']='/usr/local/sbin/kafka-logs-backup.sh'
