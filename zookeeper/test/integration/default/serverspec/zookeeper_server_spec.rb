require 'serverspec'
set :backend, :exec
describe 'java' do
  #Memory Checks
  describe host_inventory['memory']['total'].delete('kB').to_i do
    it { should > 131072 }
  end
  %w(/etc/alternatives/java /usr/bin/java).each do |file_name|
    describe file (file_name) do
      it { should be_symlink }
    end
  end
  describe command('java -version') do
    its(:exit_status) { should eq 0 }
  end
end
describe 'zookeeper' do
  %w(/var/zookeeper/myid /opt/zookeeper/conf/zoo.cfg).each do |file_name|
    describe file(file_name) do
      it { should be_a_file }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      it { should be_mode 644 }
    end
  end
  %w(/var/log/zookeeper /var/zookeeper).each do |directory_name|
    describe file(directory_name) do
      it { should be_a_directory }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      it { should be_mode 755 }
    end

  end

  describe service('zookeeper') do
    it { should be_enabled }

  end
end