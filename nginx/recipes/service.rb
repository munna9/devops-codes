service node['nginx']['service']['name'] do
  supports [ :enable, :start, :stop, :restart, :status, :reload]
  action [ :enable, :start ]
end