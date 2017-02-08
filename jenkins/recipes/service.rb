service node['jenkins']['service']['name'] do
  supports [:enable,:start, :restart,:status]
  action [:enable, :start]
end