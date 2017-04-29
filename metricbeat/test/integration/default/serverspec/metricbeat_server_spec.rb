require 'serverspec'
set :backend, :exec

describe 'metricbeat' do
  describe package('metricbeat') do
    it { should be_installed }
  end
  describe service('metricbeat') do
    it { should be_enabled }
  end
  describe command('metricbeat.sh -configtest') do
    its(:stdout) { should match /OK/ }
  end
end