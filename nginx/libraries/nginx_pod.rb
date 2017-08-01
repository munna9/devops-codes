module NginxCookbook
  class NginxBase < Chef::Resource
    resource_name :nginx_pod
    provides :nginx_pod
    default_action :create
    property :vault_name, String
    property :app_name, String, name_property: true

    action :create do
      service_dict = get_metadata vault_name,app_name
      if service_dict
        if service_dict['hosts'].any?
          create_ssl_certificate service_dict['ssl_certificate'] if service_dict['ssl_certificate']
          template "#{node['nginx']['app']['conf_directory']}/#{service_dict['nginx_conf_file']}" do
            source "pod/#{service_dict['nginx_template']}.erb"
            variables(
              :service_name     => service_dict['service_name'],
              :context_name     => service_dict['context_name'],
              :hosts            => service_dict['hosts'],
              :application_port => service_dict['application_port'],
              :uri              => service_dict['uri'],
              :service_port     => service_dict['service_port'],
              :ssl_certificate  => service_dict['ssl_certificate'],
              :keep_alive       => service_dict['keep_alive']
            )
            sensitive true
            notifies :reload, "docker_container[#{node['pod_container_name']}]"
          end
        end
      end
      addon_dict = get_addondata vault_name,app_name
      if addon_dict
        if addon_dict.keys.any?
          create_ssl_certificate addon_dict['ssl_certificate'] if addon_dict['ssl_certificate']
          template "#{node['nginx']['app']['conf_directory']}/#{addon_dict['nginx_conf_file']}"  do
            source "addons/#{addon_dict['nginx_template']}.erb"
            variables(
              :service_name   => addon_dict['service_name'],
              :uri            => addon_dict['uri'],
              :service_port   => addon_dict['service_port'],
              :context_name   => addon_dict['context_name'],
              :ssl_certificate  => addon_dict['ssl_certificate']
            )
            sensitive true
            notifies :reload, "docker_container[#{node['pod_container_name']}]"
          end
        end
      end
    end
  end
end
