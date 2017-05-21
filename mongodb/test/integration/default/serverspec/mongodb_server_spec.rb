require 'serverspec'
set :backend, :exec
describe package('mongodb-org') do
  it { should be_installed }
end
# #Service checks
describe service('mongod') do
  it { should be_running }
  it { should be_enabled }
  it { should be_enabled.with_level(3) }
  it { should be_enabled.with_level(5) }
end
#Port checks
describe port(27017) do
  it { should be_listening }
end
