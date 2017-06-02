require 'serverspec'
set :backend, :exec

describe 'awscli' do
  describe command('/usr/bin/env pip -V') do
    its(:exit_status) { should eq 0 }
  end
  describe command('/usr/bin/env aws --version') do
    its(:exit_status) { should eq 0 }
  end
end
#
# describe 'aws-inspector-agent' do
#   describe package('AwsAgent') do
#     it { should be_installed }
#   end
#   if ['debian', 'ubuntu'].include?(os[:family])
#     describe package('awsagent') do
#       it { should be_installed }
#     end
#   end
# end
describe 'profile' do
  describe file('/root/.aws/config') do
    it { should be_file }
    it { should exist }
    it { should be_mode 600 }
    it { should be_owned_by 'root' }
  end
end