[node['icinga']['ssl']['home_directory'], node['icinga']['ssl']['base_directory'], "#{node['icinga']['ssl']['base_directory']}/ca"].each  do |directory_name|
    directory directory_name do
    mode '0700'
    owner node['icinga']['service']['owner']
    group node['icinga']['service']['group']
    end
end
icinga_credentials=data_bag_item('credentials','icinga')

%w(ca.crt ca.key).each do |file_name|
  file "#{node['icinga']['ssl']['base_directory']}/ca/#{file_name}" do
    content icinga_credentials['master'][file_name]
    owner node['icinga']['service']['owner']
    group node['icinga']['service']['group']
    sensitive true
  end
end
file "#{node['icinga']['ssl']['home_directory']}/ca.crt" do
  content icinga_credentials['master']['ca.crt']
  owner node['icinga']['service']['owner']
  group node['icinga']['service']['group']
  sensitive true
end
execute "Master certificate - generate CSR" do
  cwd node['icinga']['ssl']['home_directory']
  command "icinga2 pki new-cert --cn #{node['fqdn']} --key #{node['fqdn']}.key --csr #{node['fqdn']}.csr"
  creates "#{node['icinga']['ssl']['home_directory']}/#{node['fqdn']}.csr"
end
execute "Master certificate - signup CSR" do
  cwd node['icinga']['ssl']['home_directory']
  command "icinga2 pki sign-csr --csr #{node['fqdn']}.csr --cert #{node['fqdn']}.crt"
  creates "#{node['icinga']['ssl']['home_directory']}/#{node['fqdn']}.crt"
end
template "Master - Api configuration" do
  path "#{node['icinga']['conf']['home_directory']}/api-users.conf"
  source "master/api-users.conf.erb"
  owner node['icinga']['service']['owner']
  group node['icinga']['service']['group']
  sensitive true
  variables(
    :username      => icinga_credentials['master']['api']['username'],
    :password      => icinga_credentials['master']['api']['password'],
    :listener_port => node['icinga']['api']['listner_port']
  )
  notifies :restart, "service[#{node['icinga']['service']['name']}]"
end
template "Master - Constants configuration" do
  path "#{node['icinga']['conf']['base_directory']}/constants.conf"
  source "master/constants.conf.erb"
  owner node['icinga']['service']['owner']
  group node['icinga']['service']['group']
  sensitive true
  variables(
    :ticket => icinga_credentials['master']['ticket']
  )
  notifies :restart, "service[#{node['icinga']['service']['name']}]"
end
link "#{node['icinga']['conf']['base_directory']}/features-enabled/api.conf" do
  to "#{node['icinga']['conf']['base_directory']}/features-available/api.conf"
  notifies :restart, "service[#{node['icinga']['service']['name']}]"
end