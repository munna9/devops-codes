require 'serverspec'
set :backend, :exec

describe 'filebeat' do
  describe package('filebeat') do
    it { should be_installed }
  end
  describe service('filebeat') do
    it { should be_enabled }
  end
  describe command('filebeat.sh -configtest') do
    its(:stdout) { should match /OK/ }
  end
end