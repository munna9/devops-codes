def get_kafka_hosts
  kafka_hosts=Hash.new
  if node['kafka']['cluster']
    node['kafka']['cluster'].each do |host_name|
      _host_hash = Hash.new
      _host_hash['brokerId'] = node['kafka']['cluster'].index(host_name)+1
      _host_hash['hostname']= host_name
      kafka_hosts[host_name] = _host_hash
    end
  end
  return kafka_hosts
end
