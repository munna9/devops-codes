default['aws']['cli']['packages'] = {
  'awscli' => '1.11.55'
}
#Inspector recipe
default['aws']['inspector_agent']['uri']='https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install'
default['aws']['inspector_agent']['binary_path']='/usr/sbin/agent_install'
case node['platform_family']
  when 'rhel'
    default['aws']['inspector_agent']['binary_name']='AwsAgent'
  when 'debian'
    default['aws']['inspector_agent']['binary_name']='awsagent'
end

default['aws']['inspector_agent']['service_name']='awsagent'
