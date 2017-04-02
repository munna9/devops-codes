require 'chef/provider/lwrp_base'
class Chef
  class Provider
    class AWSLogin < Chef::Provider::LWRPBase
      provides :aws_login
      use_inline_resources
      #########
      # Actions
      #########
      action :login do
        load_aws_sdk
        $credentials=get_arn_credentials if new_resource.arn_role
      end
      ###########
      # Methods
      ###########
      def whyrun_supported?
        true
      end

      def load_aws_sdk
        Chef::Log.info("Loading AWS SDK")
        gem 'aws-sdk', node['aws']['sdk_gem_version']
        require 'aws-sdk'
        Chef::Log.debug("Node has aws-sdk #{node['aws']['sdk_gem_version']} installed. No need to install gem.s")
      rescue LoadError
        Chef::Log.debug("Did not find aws-sdk version #{node['aws']['sdk_gem_version']} installed. Installing now")
        chef_gem 'aws-sdk' do
          version node['aws']['sdk_gem_version']
          compile_time true
        end
        require 'aws-sdk'
      end

      def get_key_credentials
        _role_credentials=Aws::Credentials(access_key_id: new_resource.access_key_id,
                                           secret_access_key: new_resource.secret_access_key)
        return _role_credentials
      end

      def get_arn_credentials
        role_arn="arn:aws:iam::#{new_resource.account_id}:role/#{new_resource.arn_role}"
        _role_credentials=Aws::AssumeRoleCredentials.new(role_arn: "#{role_arn}",
                                                        role_session_name: 'aws-login',
                                                        region: new_resource.region_name)
        return _role_credentials
      end
    end
  end
end