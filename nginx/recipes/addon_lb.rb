if node['nginx']['addon-lb']
  node['nginx']['addon-lb'].each do |addon_app,addon_metadata|
    template "#{node['nginx']['app']['conf_directory']}/#{addon_app}_addon.conf"  do
      source "addons/#{addon_metadata['nginx_template']}.erb"
      variables(
        :service_name   => addon_app,
        :uri            => addon_metadata['uri'],
        :service_port   => addon_metadata['service_port'],
        :context_name   => (addon_metadata['context_name'].nil?)? '/' : "/#{addon_metadata['context_name']}"
      )
      sensitive true
      notifies :reload, "docker_container[#{node['pod_container_name']}]"
    end
  end
end