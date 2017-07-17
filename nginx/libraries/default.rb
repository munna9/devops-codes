def create_ssl_certificate certificate_name
  directory node['nginx']['ssl']['base_directory']
  certificates=data_bag_item('certificates',certificate_name)
  %w(crt key).each do |file_name|
    file "#{node['nginx']['ssl']['base_directory']}/#{certificate_name}.#{file_name}" do
      content certificates[file_name]
      sensitive true
      not_if { ::File.exist?("#{node['nginx']['ssl']['base_directory']}/#{certificate_name}.#{file_name}") }
    end
  end
end

def get_metadata vault_name, app_name
  metadata_dict=Hash.new
  host_array=Array.new
  if Chef::Config[:solo] and not chef_solo_search_installed?
    Chef::Log.warn("This recipe uses search. Chef Solo does not support search unless you install the chef-solo-search cookbook.")
  else
    data_json = data_bag_item(vault_name, app_name)
    if data_json.key?(node.chef_environment)
      nginx_object = data_json[node.chef_environment]['nginx-pod']
      if nginx_object
        metadata_dict['service_name']=app_name
        metadata_dict['uri']=nginx_object['uri']
        metadata_dict['ssl_certificate']=(nginx_object['ssl_certificate'].nil?) ? 'phenompeople' : nginx_object['ssl_certificate']
        metadata_dict['nginx_conf_file']="#{app_name}.conf"
        metadata_dict['nginx_template']=nginx_object['nginx_template']
        metadata_dict['service_port']=(nginx_object['service_port'].nil?)? 80 :  nginx_object['service_port']
        metadata_dict['application_port']=nginx_object['application_port']
        metadata_dict['keep_alive']=(nginx_object['keep_alive'].nil?)? 10 : nginx_object['keep_alive']
        metadata_dict['context_name']=(nginx_object['context_name'].nil?)? '/' : "/#{nginx_object['context_name']}"
        metadata_dict['deploy_recipe']=(nginx_object['deploy_recipe'].nil?)? 'ecr_deploy':nginx_object['deploy_recipe']
        metadata_dict['app_name']=(nginx_object['app_name'].nil?)?app_name:nginx_object['app_name']

        recipe_name="#{metadata_dict['app_name']}\\:\\:#{metadata_dict['deploy_recipe']}"

        search(:node,"recipes:#{recipe_name} AND chef_environment:#{node.chef_environment}").each do |node_name|
          host_array << node_name['ipaddress']
        end

        metadata_dict['hosts']=host_array
        return metadata_dict
      end
    end
  end
end

