service node['aws']['inspector_agent']['service'] do
  supports [:start, :stop, :restart, :enable, :disable ]
  action [:start, :enable]
end