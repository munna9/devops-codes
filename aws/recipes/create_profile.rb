aws_home_directory = "#{node['etc']['passwd']['root']['dir']}/.aws"
directory aws_home_directory do
  recursive true
  action :create
end
file "#{aws_home_directory}/config" do
  content "[default]\nregion = #{node['aws_region']}"
  mode "0600"
  sensitive true
end