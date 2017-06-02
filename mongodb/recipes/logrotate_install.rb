template "#{node['mongodb']['app']['base_directory']}/logrotate.sh" do
	source 'logrotate.sh.erb'
	mode 0777
	sensitive true
end

cron 'Mongodb-logrotate' do
  hour '0'
  minute '03'
  command "#{node['mongodb']['app']['base_directory']}/logrotate.sh"
end
    
  