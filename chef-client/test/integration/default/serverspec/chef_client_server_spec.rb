require 'serverspec'

set :backend, :exec

describe('chef-client') {
  %w(/usr/bin/chef-client /var/log/chef/client.log /etc/chef/encrypted_data_bag_secret /etc/logrotate.d/chef-client /var/lock/subsys/chef-client ).each do |file_name|
    describe file file_name do
      it { should exist }
      it { should be_file }
    end
  end
  %w(/etc/chef /var/log/chef /var/lock/subsys).each do |dir_name|
    describe file dir_name do
      it { should exist }
      it { should be_directory }
    end
  end
}