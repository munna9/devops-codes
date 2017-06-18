#################################
## Update Syslimits
################################
cookbook_file "/etc/security/limits.d/#{node['mongodb']['service']['owner']}.conf" do
  source 'mongod.conf'
  sensitive true
end
#################################
# Disable Transparent Huge Pages
#################################
%w(defrag enabled).each do |file_name|
  execute "Update - #{file_name}" do
    command "echo never > /sys/kernel/mm/transparent_hugepage/#{file_name}"
    only_if { ::File.readlines("/sys/kernel/mm/transparent_hugepage/#{file_name}").grep(/\[never\]/).empty? }
  end
end
execute 'set-noop' do
  command "grubby --update-kernel=ALL --args='elevator=noop';touch #{Chef::Config['file_cache_path']}/.noop-updated"
  creates "#{Chef::Config['file_cache_path']}/.noop-updated"
end
##############################
#Disable SELinux
##############################
cmd = Mixlib::ShellOut.new("getenforce")
cmd.run_command
result=cmd.stdout.split(' ')
execute 'set-selinux' do
  command "/usr/sbin/setenforce 0"
  not_if do
    result[0]=='Disabled'
  end
end
######################
#Sysctl Update options
######################
template node['mongodb']['sysctl']['conf'] do
  source '01-mongod.conf.erb'
  sensitive true
  notifies :run, 'ruby_block[update-sysctl]'
end
ruby_block 'update-sysctl' do
  block do
    cmd = Mixlib::ShellOut.new("sysctl -p #{node['mongodb']['sysctl']['conf']}")
    cmd.run_command
  end
  action :nothing
end
######################
#Blockdev support
#####################
ruby_block 'BlockDev-Read Ahead' do
  block do
    drive_line=File.read('/proc/mounts').lines.grep(/#{node['mongodb']['storage']['base_directory']}/)[0].split(' ')
    if drive_line.any?
      drive_to_check=drive_line[0]
      lsblk_command="lsblk #{drive_to_check} -no PKNAME,KNAME"
      cmd=Mixlib::ShellOut.new(lsblk_command)
      cmd.run_command
      result=cmd.stdout.split(' ')
      result=result.uniq
      result.reject(&:empty?)
      result.each do |each_partition|
        _read_command="blockdev --getra /dev/#{each_partition}"
        cmd=Mixlib::ShellOut.new(_read_command)
        cmd.run_command
        result=cmd.stdout.split(' ')
        if result[0]!='0'
          _command="blockdev --setra 0 /dev/#{each_partition}"
          cmd=Mixlib::ShellOut.new(_command)
          cmd.run_command
          Chef::Log.info("Setting Blockdev of /dev/#{each_partition} to 0")
        end
      end
    end
  end
end

