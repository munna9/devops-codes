require 'chef/resource/lwrp_base'
require File.join(File.dirname(__FILE__), 'resource_aws_login')

class Chef
  class Resource
    class ECRLogin < Chef::Resource::AWSLogin
      self.resource_name = 'ecr_login'
      actions        :login
      default_action :login
      attribute :region_name,        kind_of: String, name_attribute: true
    end
  end
end
