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