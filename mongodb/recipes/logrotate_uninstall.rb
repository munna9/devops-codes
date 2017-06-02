cron 'Mongodb-logrotate' do
    action :delete 
end

file "#{node['mongodb']['app']['base_directory']}/logrotate.sh" do
    action :delete
end

