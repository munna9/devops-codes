default['elastalert']['pin_version']=true
default['elastalert']['repo']['uri']='https://github.com/Yelp/elastalert.git'
default['elastalert']['repo']['branch']='v0.1.9'
default['elastalert']['binary']['packages'] = {
  'amazon' => {
    '2016.09' => {
      'glibc-common'     => '2.17-157.169.amzn1',
      'glibc'            => '2.17-157.169.amzn1',
      'glibc-devel'      => '2.17-157.169.amzn1',
      'glibc-headers'    => '2.17-157.169.amzn1',
      'gcc'              => '4.8.3-3.20.amzn1',
      'python27-devel'   => '2.7.12-2.120.amzn1'
    }
  }
}
default['elastalert']['pip']['packages'] ={
  'argparse'              =>  '1.3.0',
  'aws-requests-auth'     =>  '0.2.5',
  'blist'                 =>  '1.3.6',
  'boto'                  =>  '2.34.0',
  'botocore'              =>  '1.4.5',
  'configparser'          =>  '3.5.0',
  'croniter'              =>  '0.3.8',
  'elasticsearch'         =>  '5.2.0',
  'jira'                  =>  '0.32',
  'jsonschema'            =>  '2.2.0',
  'mock'                  =>  '1.0.0',
  'oauthlib'              =>  '0.7.2',
  'PyStaticConfiguration' =>  '0.9.0',
  'python-dateutil'       =>  '2.4.0',
  'PyYAML'                =>  '3.11',
  'requests'              =>  '2.5.1',
  'requests-oauthlib'     =>  '0.4.2',
  'simplejson'            =>  '3.3.0',
  'six'                   =>  '1.10.0',
  'stomp.py'              =>  '4.1.15',
  'supervisor'            =>  '3.1.2',
  'texttable'             =>  '0.8.4',
  'tlslite'               =>  '0.4.8',
  'exotel'                =>  '0.1.1',
  'twilio'                =>  '5.6.0',
  'unittest2'             =>  '0.8.0',
  'urllib3'               =>  '1.8.2',
  'wsgiref'               =>  '0.1.2'
}
default['elastalert']['app']['base_directory']='/opt'
default['elastalert']['app']['app_directory']="#{node['elastalert']['app']['base_directory']}/elastalert"
default['elastalert']['app']['conf_directory']="#{node['elastalert']['app']['app_directory']}/conf.d"
default['elastalert']['app']['rules_directory']="#{node['elastalert']['app']['app_directory']}/rules.d"
default['elastalert']['app']['pooling']=1

default['elastalert']['service']['name']='elastalert'
default['elastalert']['alerts']=%w(spike)