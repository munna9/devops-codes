service node['elasticsearch']['service']['name'] do
  supports [ :start, :restart, :stop, :reload ]
  action [:enable, :start]
end
