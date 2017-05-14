yum_repository 'mongodb-org' do
  description 'Mongo DB Repository'
  baseurl node['mongodb']['download']['uri']
  gpgcheck false
end
node['mongodb']['binary']['packages'][node['mongodb']['major']['version']][node['platform']].each do |package_name,package_version|
  package package_name do
    version package_version if node['mongodb']['pin_version']
  end
end