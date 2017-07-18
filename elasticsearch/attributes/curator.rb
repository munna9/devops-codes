default['curator']['pip']['packages'] = {
  'certifi'               => '2017.1.23',
  'click'                 => '6.7',
  'pyyaml'                => '3.12',
  'urllib3'               => '1.20',
  'voluptuous'            => '0.9.3',
  'elasticsearch'         => '5.2.0',
  'elasticsearch-curator' => '4.2.6'
}
default['curator']['conf']['home_directory']='/etc/elastic-curator'

default['curator']['indices']={
  'logstash'=> {
    'close'           => 5,
    'delete_indices'  => 15
  },
  'metricbeat' => {
    'close'           => 3,
    'delete_indices'  => 7
  }
}
