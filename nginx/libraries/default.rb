def create_ssl_certificate certificate_name
  directory node['nginx']['ssl']['base_directory']
  certificates=data_bag_item('certificates',certificate_name)
  %w(crt key).each do |file_name|
    file "#{node['nginx']['ssl']['base_directory']}/#{certificate_name}.#{file_name}" do
      content certificates[file_name]
      sensitive true
    end
  end
end