require 'chef/resource/lwrp_base'
require File.join(File.dirname(__FILE__), 'provider_aws_login')
class Chef
  class Provider
    class ECRLogin < Chef::Provider::AWSLogin
      provides :ecr_login
      use_inline_resources
      #########
      # Actions
      #########
      action :login do
        load_aws_sdk
        aws_home_directory = "#{node['etc']['passwd']['root']['dir']}/.aws"
        directory aws_home_directory
        file "#{aws_home_directory}/config" do
          content "[default]\nregion = #{node['aws']['region']}"
          mode "0600"
          sensitive true
        end
        if new_resource.arn_role
          $credentials=get_arn_credentials
          $ecr_client=Aws::ECR::Client.new(region: new_resource.region_name,
                                           credentials:$credentials)
        end
        if new_resource.access_key_id && new_resource.secret_access_key
          file "#{aws_home_directory}/credentials" do
            content "[default]\naws_access_key_id = #{new_resource.access_key_id}\naws_secret_access_key = #{new_resource.secret_access_key}"
            mode "0600"
            sensitive true
          end
          $ecr_client=Aws::ECR::Client.new(region: new_resource.region_name,
                                           access_key_id: new_resource.access_key_id,
                                           secret_access_key: new_resource.secret_access_key)
        end

        begin
          resp = $ecr_client.get_authorization_token({})
          resp = resp.to_h
          node.default['aws']['authorization_token']=resp[:authorization_data][0][:authorization_token]
          node.default['aws']['proxy_endpoint']=resp[:authorization_data][0][:proxy_endpoint]
          node.default['aws']['serveraddress']=resp[:authorization_data][0][:proxy_endpoint].split('//')[1]
          aws_config
        rescue NoMethodError
          Chef::Log.fatal ("Authentication Token Missing")
        end
      end
      ###########
      # Methods
      ###########
      def whyrun_supported?
        true
      end

      def aws_config
        ecr_command = "aws ecr get-login"
        cmd = Mixlib::ShellOut.new("aws ecr get-login --region #{node['aws']['region']}")
        cmd.run_command
        result = cmd.stdout.split(' ')
        node.default['aws']['username']=result[3]
        node.default['aws']['password']=result[5]
      end
    end
  end
end

