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
describe 'nginx' do
  describe package('nginx') do
    it { should be_installed }
  end
  #Service checks
  describe service('nginx') do
    it { should be_running }
    it { should be_enabled }
    it { should be_enabled.with_level(3) }
    it { should be_enabled.with_level(5) }
  end
  #Port checks
  describe port(80) do
    it { should be_listening }
  end
end
describe 'jenkins' do
  #Memory Checks
  describe host_inventory['memory']['total'].delete('kB').to_i do
    it { should > 256000 }
  end
  #Package checks
  describe package('jenkins') do
    it { should be_installed }
  end
  #Service checks
  describe service('jenkins') do
    it { should be_running }
    it { should be_enabled }
    it { should be_enabled.with_level(3) }
    it { should be_enabled.with_level(5) }
  end
  #Port checks
  describe port(8080) do
    it { should be_listening }
  end
end
