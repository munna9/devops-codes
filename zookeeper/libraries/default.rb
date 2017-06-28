def get_zk_hosts
  zk_hosts=Hash.new
  if node['zookeeper']['cluster']
    node['zookeeper']['cluster'].each do |host_name|
      _host_hash = Hash.new
      _host_hash['myId'] = node['zookeeper']['cluster'].index(host_name)+1
      if node['hostname'] == host_name
        _host_hash['hostname']='0.0.0.0'
      else
        _host_hash['hostname']=host_name
      end
      zk_hosts[host_name] = _host_hash
    end
  end
  return zk_hosts
end
