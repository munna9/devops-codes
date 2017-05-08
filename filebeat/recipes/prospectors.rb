begin
  app_files=data_bag_item('beat_prospectors',node.chef_environment)
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  app_files=data_bag_item('beat_prospectors',"_default")
end
node.default['filebeat']['files_to_watch'].merge!(app_files['app_files_to_watch'])

fileWatcher(node['filebeat']['conf']['home_directory'],node['filebeat']['files_to_watch'].keys)

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
