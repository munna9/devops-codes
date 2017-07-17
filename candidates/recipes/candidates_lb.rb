template "#{node['nginx']['app']['conf_directory']}/candidates_elb.conf" do
  source 'candidates_elb.conf.erb'
  notifies :reload, "docker_container[#{node['pod_container_name']}]"
end
