module DockerCookbook
  class DockerExec < DockerBase
    resource_name :ecr_undeploy
    provides :ecr_undeploy

    property :app_name, String, name_property: true
    property :vault_name, String
    property :container_name, String
    property :deploy_kill_after, Numeric, default: 30
    property :deploy_read_timeout, Numeric, default: 30
    property :deploy_write_timeout, Numeric, default: 60
    ########
    # Actions
    ########

    default_action :un_deploy
    
    action :un_deploy do
      docker_registry 'ECR Login' do
        serveraddress node['aws']['serveraddress']
        username node['aws']['username']
        password node['aws']['password']
      end
      if container_name
        docker_containers = container_name if container_name
      else
        data_record = data_bag_item(vault_name, app_name)
        docker_containers = data_record[node.chef_environment]['ecr']
      end
      docker_containers.each_pair do |container,container_metadata|
        container_metadata['registry_name']=node['aws']['serveraddress']
        container_metadata['container_name']=container
        container_metadata['tag_name']=(container_metadata['tag_name'].nil?) ? 'latest' : container_metadata['tag_name']
        ports_array = Array.new
        unless container_metadata['ports'].nil?
          container_metadata['ports'].each do |source,destination|
            ports_array.push("#{source}:#{destination}")
          end
        end
        volumes_array = Array.new
        unless container_metadata['volumes'].nil?
          container_metadata['volumes'].each do |source,destination|
            volumes_array.push("#{source}:#{destination}")
          end
        end
        aws_elastic_lb "ELB-Detach-#{container}" do
          name container_metadata['elb_name']
          action :deregister
          not_if { container_metadata['elb_name'].nil? }
          notifies :run,            "ruby_block[Draining-#{container}]",        :immediately if container_metadata['drain_time']
        end

        docker_container container do
          repo "#{container_metadata['registry_name']}/#{container_metadata['image_name']}"
          tag container_metadata['tag_name']
          env container_metadata['environment_variables'] if container_metadata['environment_variables']
          port ports_array            unless ports_array.nil?
          volumes volumes_array       unless volumes_array.nil?
          kill_after deploy_kill_after
          read_timeout deploy_read_timeout
          write_timeout deploy_write_timeout
          action :stop
          notifies :delete,         "docker_container[#{container}]",           :immediately
        end
        docker_image "Docker Remove - #{container_metadata['image_name']}" do
          repo "#{container_metadata['registry_name']}/#{container_metadata['image_name']}"
          tag container_metadata['tag_name']
          action :remove
        end
        ruby_block "Draining-#{container}" do
          block do
            sleep(container_metadata['drain_time'])
          end
          action :nothing
        end
      end
    end
  end
end