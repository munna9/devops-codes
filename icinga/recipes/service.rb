service node['icinga']['service']['name'] do
  supports [:start, :stop, :reload, :enable, :disable]
  action [:enable, :start]
end
