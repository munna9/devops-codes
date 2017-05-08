service node['mysql']['service']['name'] do
  supports [:start, :stop, :reload, :enable, :disable]
  action [:enable, :start]
end