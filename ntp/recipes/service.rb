service node['ntp']['service']['name'] do
  # case node['platform']
  #   when 'ubuntu'
  #     if node['platform_version'].to_f >=14.04
  #       provider Chef::Provider::Service::Upstart
  #     end
  # end
  supports [:status, :restart, :start, :enable ]
  action   [:enable, :start]
end