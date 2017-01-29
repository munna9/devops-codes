service 'chef-client' do
  action [:disable,:stop]
end
[node['chef-client']['conf']['directory'], node['chef-client']['log']['directory'], node['chef-client']['lock']['directory']].each do |dir_name|
  directory  dir_name do
    recursive true
    action :delete
  end
end
[node['chef-client']['log']['filename'], node['chef-client']['lock']['filename'],node['chef-client']['conf']['encrypted_data_bag_secret'], node['chef-client']['service']['conf_file'], node['chef-client']['log']['conf_file']].each do |file_name|
  file file_name do
    action :delete
  end
end
# [node['chef-client']['log']['filename'], node['chef-client']['lock']['filename'], node['chef-client']['conf']['encrypted_data_bag_secret'], node['chef-client']['conf']['sysconfig']].each do |file_name|
#   file file_name do
#     action :delete
#   end
# end
