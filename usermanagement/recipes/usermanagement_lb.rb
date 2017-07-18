template "#{node['nginx']['app']['conf_directory']}/usermanagement_lb.conf" do
  source 'usermanagement_lb.conf.erb'
  notifies :reload, "docker_container[#{node['pod_container_name']}]"
end
