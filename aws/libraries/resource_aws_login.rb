require 'chef/resource/lwrp_base'
class Chef
  class Resource
    class AWSLogin <  Chef::Resource::LWRPBase
      self.resource_name = 'aws_login'
      actions :login
      default_action :login

      attribute :region_name,        kind_of: String, name_attribute: true
      attribute :account_id,         kind_of: Fixnum
      attribute :access_key_id,      kind_of: String
      attribute :secret_access_key,  kind_of: String
      attribute :arn_role,           kind_of: String, default: "Chefnode"
    end
  end
end