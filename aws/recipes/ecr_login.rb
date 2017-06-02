ecr_login node['aws_region'] do
  arn_role node['aws']['arn_role']                      if node['aws']['arn_role']
  access_key_id node['aws']['access_key_id']            if node['aws']['access_key_id']
  secret_access_key node['aws']['secret_access_key']    if node['aws']['secret_access_key']
end