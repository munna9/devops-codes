default['ntp']['pin_version']=true

default['ntp']['client']['packages'] = {
  'amazon' => {
    '2017.03' => {
      'ntp' => '4.2.6p5-44.34.amzn1'
    },
    '2016.09' => {
      'ntp' => '4.2.6p5-44.34.amzn1'
    },
    '2016.03' => {
      'ntp' => '4.2.6p5-44.34.amzn1'
    },
    '2015.09' => {
      'ntp' => '4.2.6p5-44.34.amzn1'
    }
  },
  'centos' => {
    '7.3.1611' => {
      'ntp' => '4.2.6p5-25.el7.centos.2'
    },
    '7.2.1511' => {
      'ntp' => '4.2.6p5-25.el7.centos'
    },
    '7.0.1406' => {
      'ntp' => '4.2.6p5-25.el7.centos'
    },
  },
  'ubuntu' => {
    '14.04' =>  {
      'ntp' => '1:4.2.6.p5+dfsg-3ubuntu2',
    },
    '16.04' => {
      'ntp' => '1:4.2.8p4+dfsg-3ubuntu5.3'
    }
  }
}

default['ntp']['service']['owner'] = 'root'
default['ntp']['service']['group'] = 'root'

case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['ntp']['service']['name']  = 'ntpd'
  when 'debian', 'ubuntu'
    default['ntp']['service']['name']='ntp'
end
