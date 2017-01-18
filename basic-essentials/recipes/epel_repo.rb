if node['platform_family'] == 'rhel'
  remote_file 'epel-repo' do
    path "#{Chef::Config['file_cache_path']}/epel-release-latest-7.noarch.rpm"
    source node['epel']['repo']['uri']
    action :create
    notifies :install, "package[#{Chef::Config['file_cache_path']}/epel-release-latest-7.noarch.rpm]", :immediately
  end
  package "#{Chef::Config['file_cache_path']}/epel-release-latest-7.noarch.rpm" do
    action :nothing
  end
end
