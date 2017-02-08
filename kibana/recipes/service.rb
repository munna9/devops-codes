service node['kibana']['service']['name'] do
  supports [:restart, :start, :stop, :reload]
  action [:enable, :start]
end