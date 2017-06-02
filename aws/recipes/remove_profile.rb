aws_home_directory = "#{node['etc']['passwd']['root']['dir']}/.aws"
file "#{aws_home_directory}/config" do
  action :delete
end
directory aws_home_directory do
  action :delete
end