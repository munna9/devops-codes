if node['platform_family'] == 'rhel'
  package "#{Chef::Config['file_cache_path']}/epel-release-latest-7.noarch.rpm" do
    action :remove
  end
  file "#{Chef::Config['file_cache_path']}/epel-release-latest-7.noarch.rpm" do
    action :delete
  end
end
