chef_nodes=Hash.new
ruby_block 'chef_nodes' do
  if Chef::Config['solo']
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search. ')
  else
    search(:node,'name:*', :filter_result => {
      'fqdn': ['fqdn'],
      'platform': ['platform'],
      'ipaddress': ['ipaddress'],
      'environment': ['chef_environment'],
      'role':['role'],
      'roles': ['roles'],
    }).each do |node_name|
      chef_nodes[node_name['fqdn']]=node_name
      chef_nodes[node_name['fqdn']]['short_name']=node_name['fqdn'].split('.')[0]
    end
  end
end
directory node['icinga']['conf']['chef_obj_directory'] do
  owner node['icinga']['service']['owner']
  group node['icinga']['service']['group']
  recursive true
end
phenom_groups = Hash.new
phenom_users=Hash.new
_icinga_groups = data_bag_item('phenom_groups','icinga')
_icinga_groups.delete('id')
_icinga_groups.each do |group_name,group_members|
 phenom_groups[group_name]=group_members
end
data_bag('phenom_users').each do |phenom_user|
  current_user = data_bag_item('phenom_users',phenom_user)
  _current_groups = Array.new
  _icinga_user=Hash.new
  _icinga_user['uid']=phenom_user
  _icinga_user['email']=current_user['email']
  _icinga_user['pager']=current_user['pager']
  _icinga_user['display_name']=current_user['display_name']
  phenom_groups.each do |phenom_group,member_array|
    _current_groups << phenom_group if member_array.include?(phenom_user)
  end
  _icinga_user['groups']=_current_groups.uniq
  phenom_users[phenom_user]=_icinga_user
end
template "#{node['icinga']['conf']['chef_obj_directory']}/chef-user-groups.conf" do
  source 'chef-objects/chef-user-groups.conf.erb'
  owner node['icinga']['service']['owner']
  group node['icinga']['service']['group']
  mode '0640'
  sensitive true
  variables(
    :user_groups => phenom_groups.keys
  )
  notifies :reload, "service[#{node['icinga']['service']['name']}]"
end
%w(users hosts services groups templates).each do |file_name|
  file "#{node['icinga']['conf']['home_directory']}/#{file_name}.conf" do
    action :delete
    notifies :reload, "service[#{node['icinga']['service']['name']}]"
  end
  template "#{node['icinga']['conf']['chef_obj_directory']}/chef-#{file_name}.conf" do
    source "chef-objects/chef-#{file_name}.conf.erb"
    owner node['icinga']['service']['owner']
    group node['icinga']['service']['group']
    mode '0640'
    sensitive true
    variables(
      :host_groups => ['centos', 'redhat', 'amazon', 'scientific', 'oracle', 'debian', 'ubuntu' ],
      :chef_nodes => chef_nodes,
      :phenom_users => phenom_users
    )
    notifies :reload, "service[#{node['icinga']['service']['name']}]"
  end
end
