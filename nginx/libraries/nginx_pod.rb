module NginxCookbook
  class NginxBase < Chef::Resource
    provides :nginx_pod
    default_action :create
    property :vault_name, String
    property :app_name, String, name_property: true

    action :create do
      directory node['nginx']['app']['conf_directory'] do
        recursive true
      end
      data_record = data_bag_item(vault_name,app_name)
      nginx_configurations = data_record[node.chef_environment]['nginx-pod']
      nginx_configurations.each_pair do |service_name,service_metadata|
        create_ssl_certificate service_metadata['ssl_certificate']
        template "#{node['nginx']['app']['conf_directory']}/#{service_metadata['nginx_conf_file']}" do
          source "#{service_metadata['nginx_template']}.erb"
          sensitive true
          variables(
            :service_name => service_name,
            :uri => service_metadata['uri'],
            :ssl_certificate => service_metadata['ssl_certificate'],
            :service_port => service_metadata['service_port'],
            :application_port => service_metadata['app_port']
          )
        end


      end
    end
  end
end