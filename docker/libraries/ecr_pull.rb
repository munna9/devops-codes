module DockerCookbook
  class EcrPull < DockerBase
    resource_name :ecr_pull
    provides :ecr_pull
    property :app_name, String, name_property: true
    property :vault_name, String
    ########
    # Actions
    ########
    default_action :pull
    action :pull do
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
        docker_image "Docker Pull - #{container_metadata['image_name']}" do
          repo "#{container_metadata['registry_name']}/#{container_metadata['image_name']}"
          tag container_metadata['tag_name']
          action :pull
        end
      end
    end
  end
end
