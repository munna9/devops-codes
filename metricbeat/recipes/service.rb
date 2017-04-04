service node['metricbeat']['service']['name'] do
  supports [ :enable, :restart, :start, :stop, :reload ]
  action [:start, :enable]
end
