cookbook_file '/etc/profile.d/docker.sh' do
  source 'docker.sh'
  sensitive true
  mode '0777'
end
directory node['docker']['wrapper']['base_directory']
node['docker']['wrapper']['scripts'].each do |script_name|
  cookbook_file "#{node['docker']['wrapper']['base_directory']}/#{script_name}" do
    source "#{script_name}.sh"
    sensitive true
    mode '0777'
  end
end
cron 'docker-clean' do
  hour '00'
  minute '00'
  mailto node['phenom']['admin_email']
  command "#{node['docker']['wrapper']['base_directory']}/docker-clean 1> /dev/null"
end