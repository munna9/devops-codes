mongodb_credentials=data_bag_item('credentials','mongodb')
directory "Master - #{node['mongodb']['storage']['path']}" do
  path node['mongodb']['storage']['path']
  recursive true
  owner node['mongodb']['service']['owner']
  group node['mongodb']['service']['group']
end
template "Master - #{node['mongodb']['conf']['file']}" do
  path node['mongodb']['conf']['file']
  source 'master/mongod.conf.erb'
  notifies :restart, "service[#{node['mongodb']['service']['name']}]", :immediately
end
template "#{node['mongodb']['app']['base_directory']}/mongo_users.js" do
  source 'master/mongo_users.js.erb'
  sensitive true
  mode '0400'
  variables(
    :user_hash => mongodb_credentials['users']
  )
  notifies :run, "execute[update-user-accounts]", :immediately
end
execute "update-user-accounts" do
  command "#{node['mongodb']['binary']['path']} < #{node['mongodb']['app']['base_directory']}/mongo_users.js;touch #{node['mongodb']['app']['base_directory']}/.users_created"
  creates "#{node['mongodb']['app']['base_directory']}/.users_created"
  action :nothing
end

mongo_slaves =Array.new
mongo_masters=Array.new

recipe_name="mongodb\\:\\:configure"
if Chef::Config[:solo] and not chef_solo_search_installed?
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search unless you install the chef-solo-search cookbook.")
else
  search(:node,"recipes:#{recipe_name} AND chef_environment:#{node.chef_environment}").each do |node_name|
    mongo_slaves << node_name['ipaddress']
  end
end
recipe_name="mongodb\\:\\:master"
if Chef::Config[:solo] and not chef_solo_search_installed?
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search unless you install the chef-solo-search cookbook.")
else
  search(:node,"recipes:#{recipe_name} AND chef_environment:#{node.chef_environment}").each do |node_name|
    mongo_masters << node_name['ipaddress']
  end
end
mongo_masters << node['ipaddress']
mongo_slaves = mongo_slaves - mongo_masters

template "#{node['mongodb']['app']['base_directory']}/mongo_replica.js" do
  source 'master/mongo_replica.js.erb'
  sensitive true
  mode '0400'
  variables(
    :slave_hosts => mongo_slaves
  )
    notifies :run, "execute[initiate-replicas]", :immediately
end
execute "initiate-replicas" do
  command "#{node['mongodb']['binary']['path']} < #{node['mongodb']['app']['base_directory']}/mongo_replica.js;touch #{node['mongodb']['app']['base_directory']}/.users_created"
  creates "#{node['mongodb']['app']['base_directory']}/.mongo_replica.created"
  action :nothing
end

