if node['platform_family'] == 'rhel'
  ["#{Chef::Config['file_cache_path']}/epel-release-latest-7.noarch.rpm", '/etc/yum.repos.d/epel.repo', '/etc/yum.repos.d/epel-testing.repo'].each do |file_name|
    file file_name do
      action :delete
    end
  end
end
