module DockerCookbook
  class EcrDeploy < DockerBase
    resource_name :ecr_deploy
    provides :ecr_deploy

    property :app_name, String, name_property: true
    property :vault_name, String
    property :deploy_kill_after, Numeric, default: 30
    property :deploy_read_timeout, Numeric, default: 30
    property :deploy_write_timeout, Numeric, default: 60
    ########
    # Actions
    ########
    default_action :deploy
    action :deploy do
      docker_registry 'ECR Login' do
        serveraddress node['aws']['serveraddress']
        username node['aws']['username']
        password node['aws']['password']
      end
      data_record = data_bag_item(vault_name, app_name)
      docker_containers = data_record[node.chef_environment]['ecr']
      directory node['docker']['container']['log_directory'] do
        mode '1777'
        recursive true
      end
      docker_containers.each_pair do |container,container_metadata|
        container_metadata['registry_name']=node['aws']['serveraddress']
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
          action   :pull
          notifies :deregister,     "aws_elastic_lb[ELB-Detach-#{container}]",  :immediately
          notifies :run,            "ruby_block[Draining-#{container}]",        :immediately if container_metadata['drain_time']
          notifies :stop,           "docker_container[#{container}]",           :immediately
          notifies :delete,         "docker_container[#{container}]",           :immediately
          notifies :register,       "aws_elastic_lb[ELB-Attach-#{container}]",  :immediately
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
        end
        ruby_block "Draining-#{container}" do
          block do
            sleep(container_metadata['drain_time'])
          end
          action :nothing
        end
        aws_elastic_lb "ELB-Attach-#{container}" do
          name container_metadata['elb_name']
          action :nothing
          not_if { container_metadata['elb_name'].nil? }
        end
        aws_elastic_lb "ELB-Detach-#{container}" do
          name container_metadata['elb_name']
          action :nothing
          not_if { container_metadata['elb_name'].nil? }
        end
      end
    end
  end
end