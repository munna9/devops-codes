package 'python'
remote_file '/usr/sbin/get-pip' do
  source node['pip']['repo']['uri']
  mode '0700'
  notifies :run, 'execute[install-pip]', :immediately
end
execute 'install-pip' do
  command "/usr/bin/env python /usr/sbin/get-pip"
  action :nothing
end

link "/usr/bin/pip" do
  to "/usr/local/bin/pip"
  only_if { ::File.exist? "/usr/local/bin/pip" }
end
