jenkins_master=Array.new

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  jenkins_master=search(:node, "role:jenkins_master AND chef_environment:#{node.chef_environment}").first
end

template 'Jenkins-Nginx-proxy' do
  source 'jenkins.conf.erb'
  path "#{node['nginx']['app']['conf_directory']}/jenkins.conf"
  variables(
    :jenkins_server_host => jenkins_master['ipaddress'],
    :jenkins_server_port => node['jenkins']['service']['port']
  )
  sensitive true
  notifies :reload, "service[#{node['nginx']['service']['name']}]"
end