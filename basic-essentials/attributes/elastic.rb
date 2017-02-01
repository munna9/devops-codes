default['elastic']['repo']['packages'] ={
  'ubuntu' => {
    '14.04' => {
      'apt-transport-https' => '1.0.1ubuntu2.17'
    },
    '16.04' => {
      'apt-transport-https' => '1.2.15ubuntu0.2'
    }
  }
}
default['elastic']['repo']['name']='elastic-repo'

case node['platform']
  when 'centos', 'redhat', 'amazon', 'scientific', 'oracle'
    default['elastic']['repo']['base_uri']='https://artifacts.elastic.co/packages/5.x/yum'
    default['elastic']['repo']['gpg_key']='https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  when 'ubuntu', 'debian'
    default['elastic']['repo']['base_uri']='https://artifacts.elastic.co/packages/5.x/apt'
    default['elastic']['repo']['gpg_key']='https://artifacts.elastic.co/GPG-KEY-elasticsearch'
end