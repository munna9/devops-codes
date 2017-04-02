link "/usr/local/bin/pip" do
  action :delete
  only_if { ::File.exist? "/usr/local/bin/pip" }
end

file node['pip']['repo']['uri'] do
  action :delete
end