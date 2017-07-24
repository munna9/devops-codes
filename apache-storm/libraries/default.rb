def get_container_name vault_name, app_name
  data_record = data_bag_item(vault_name,app_name)
  if data_record.key?(node.chef_environment)
    data_json=data_record[node.chef_environment]['docker']
    _containers=data_json.keys
    return _containers.first
  end
end
