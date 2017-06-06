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
describe 'elasticsearch' do
  describe package('elasticsearch') do
    it { should be_installed }
  end
  describe service('elasticsearch') do
    it { should be_running }
    it { should be_enabled }
  end
  describe command('sudo /usr/share/elasticsearch/bin/elasticsearch --version') do
    its(:stdout) { should match /5.2/ }
    its(:exit_status) { should eq 0 }
  end
end