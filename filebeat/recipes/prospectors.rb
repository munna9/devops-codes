parse_host_name
begin
  app_files_to_watch=data_bag_item('fb_prospectors',"#{node['host_env']}-#{node['host_role']}")
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  app_file_to_watch=data_bag_item('fb_prospectors',"_default-dummy")
end
node.default['filebeat']['files_to_watch'].merge!(app_files_to_watch['app_files_to_watch'])

node['filebeat']['files_to_watch'].each do |prospectors,conf_content|
  yml_string=conf_content.to_hash.to_yaml
  yml_string=yml_string.gsub('---','')
  yml_string=yml_string.gsub!(/^/, '  ')
  template "#{node['filebeat']['conf']['home_directory']}/#{prospectors}.yml" do
    source 'prospectors.yml.erb'
    sensitive true
    variables(
      'yml_content' =>yml_string )
    notifies :restart, "service[#{node['filebeat']['service']['name']}]"
  end
end
