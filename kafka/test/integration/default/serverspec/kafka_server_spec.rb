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
describe 'kafka' do
%w(/opt/kafka/config/zookeeper.properties /opt/kafka/config/server.properties).each do |file_name|
  describe file(file_name) do
    it { should be_a_file }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    it { should be_mode 644 }
  end
end
  describe file('/var/log/kafka') do
    it { should be_a_directory }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    it { should be_mode 755 }
  end

  describe service('kafka') do
    it { should be_running }
  end
end