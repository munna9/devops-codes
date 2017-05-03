#ChefDK

default['chefdk']['binary']['version']='1.1.16'
default['chefdk']['binary']['package'] = {
  'rhel' => 'chefdk',
  'debian'=> 'chefdk'
}
default['chefdk']['package']['name'] ={
  'rhel' => "chefdk-#{node['chefdk']['binary']['version']}-1.el7.x86_64.rpm",
  'debian' => "chefdk_#{node['chefdk']['binary']['version']}-1_amd64.deb"

}
default['chefdk']['download']['uri']= {
  'centos' => {
    '7.2.1511' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/el/7/#{node['chefdk']['package']['name'][node['platform_family']]}",
    '7.3.1611' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/el/7/#{node['chefdk']['package']['name'][node['platform_family']]}"
  },
  'amazon' => {
    '2016.09' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/el/7/#{node['chefdk']['package']['name'][node['platform_family']]}",
    '2017.03' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/el/7/#{node['chefdk']['package']['name'][node['platform_family']]}"
  },
  'ubuntu' => {
    '14.04' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/#{node['platform']}/#{node['platform_version']}/#{node['chefdk']['package']['name'][node['platform_family']]}",
    '16.04' => "https://packages.chef.io/files/stable/chefdk/#{node['chefdk']['binary']['version']}/#{node['platform']}/#{node['platform_version']}/#{node['chefdk']['package']['name'][node['platform_family']]}"
  }
}
