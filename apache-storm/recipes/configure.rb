directory node['storm']['conf']['home_directory'] do
  recursive true
end
template node['storm']['conf']['env_file'] do
  source 'storm_env.ini.erb'
end
nimbus_seeds=Array.new
recipe_name="apache-storm\\:\\:storm_nimbus_install"

if Chef::Config[:solo] and not chef_solo_search_installed?
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search unless you install the chef-solo-search cookbook.")
else
  search(:node,"recipes:#{recipe_name} AND chef_environment:#{node.chef_environment}").each do |node_name|
    nimbus_seeds << node_name['hostname']
  end
end
node.default['nimbus_seeds']=nimbus_seeds
