require 'serverspec'
set :backend, :exec

describe 'kibana' do
  describe package('kibana') do
    it { should be_installed }
  end
  describe service('kibana') do
    it { should be_running }
    it { should be_enabled }
  end
  describe command('/usr/share/kibana/bin/kibana --version') do
    its(:stdout) { should match /5.2/ }
    its(:exit_status) { should eq 0 }
  end
end