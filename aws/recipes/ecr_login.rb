unless node['aws']['access_key_id'] || node['aws']['secret_access_key']
  aws_credentials = data_bag_item('credentials','aws')
  node.default['aws']['access_key_id']=aws_credentials['access_key_id']
  node.default['aws']['secret_access_key']=aws_credentials['secret_access_key']
end
ecr_login node['aws']['region'] do
  arn_role node['aws']['arn_role']                      if node['aws']['arn_role']
  access_key_id node['aws']['access_key_id']            if node['aws']['access_key_id']
  secret_access_key node['aws']['secret_access_key']    if node['aws']['secret_access_key']
end