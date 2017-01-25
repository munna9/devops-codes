require 'serverspec'
require 'net/http'
set :backend, :exec
set :path, '/sbin:/usr/sbin:$PATH'
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
  describe port('80') do
    it { should be_listening }
  end
  describe Net::HTTP.get(URI('http://localhost/index.html')) do
    it { should match('nginx') }
  end
end