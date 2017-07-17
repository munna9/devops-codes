module DockerCookbook
  class DockerExec < DockerBase
    resource_name :docker_deploy
    provides :docker_deploy

    property :app_name, String, name_property: true
    property :vault_name, String
    property :container_name, String
    property :deploy_kill_after, Numeric, default: 30
    property :deploy_read_timeout, Numeric, default: 30
    property :deploy_write_timeout, Numeric, default: 60
    ########
    # Actions
    ########
    action :deploy do
      docker_credentials=data_bag_item('credentials','docker')
      docker_registry 'Docker login' do
        serveraddress docker_credentials['serveraddress']
        username docker_credentials['username']
        password docker_credentials['password']
      end
      if container_name
        docker_containers = container_name if container_name
      else
        data_record = data_bag_item(vault_name, app_name)
        docker_containers = data_record[node.chef_environment]['docker']
      end
      directory node['docker']['container']['log_directory'] do
        mode '1777'
        recursive true
      end
      docker_containers.each_pair do |container,container_metadata|
        container_metadata['registry_name']=docker_credentials['registry_name']
        container_metadata['container_name']=container
        container_metadata['tag_name']=(container_metadata['tag_name'].nil?) ? 'latest' : container_metadata['tag_name']
        directory "#{node['docker']['container']['log_directory']}/#{container}" do
          mode '1777'
          recursive true
        end
        ports_array = Array.new
        unless container_metadata['ports'].nil?
          container_metadata['ports'].each do |source,destination|
            ports_array.push("#{source}:#{destination}")
          end
        end
        volumes_array = Array.new
        volumes_array.push('/etc/localtime:/etc/localtime')
        unless container_metadata['volumes'].nil?
          container_metadata['volumes'].each do |source,destination|
            volumes_array.push("#{source}:#{destination}")
          end
        end

        docker_image "Docker Pull - #{container_metadata['image_name']}" do
          repo "#{container_metadata['registry_name']}/#{container_metadata['image_name']}"
          tag container_metadata['tag_name']
          action :pull
          notifies :stop,           "docker_container[#{container}]"
          notifies :delete,         "docker_container[#{container}]"
          notifies :run_if_missing, "docker_container[#{container}]"
        end
        docker_container container do
          repo "#{container_metadata['registry_name']}/#{container_metadata['image_name']}"
          tag container_metadata['tag_name']
          env container_metadata['environment_variables'] if container_metadata['environment_variables']
          hostname node['hostname'] if container_metadata['hostname']
          port ports_array if ports_array
          volumes volumes_array if volumes_array
          kill_after deploy_kill_after
          read_timeout deploy_read_timeout
          write_timeout deploy_write_timeout
        end
      end
    end
  end
end