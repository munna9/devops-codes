service node['mongodb']['service']['name'] do
  supports [:restart, :start, :stop, :reload]
  action [:enable, :start]
end