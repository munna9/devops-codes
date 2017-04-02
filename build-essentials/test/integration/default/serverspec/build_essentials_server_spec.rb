require 'serverspec'
set :backend, :exec
describe 'phenom' do
  describe user('phenom') do
    it { should exist }
    it { should belong_to_primary_group 'phenom' }
    it { should have_home_directory '/opt/phenom' }
    it { should have_login_shell '/bin/false' }
  end
end

describe 'gitclient' do
  describe package('git') do
    it { should be_installed }
  end
end

describe 'buildproperties' do
  file('/opt/phenom/builddirectories') do
    it { should be_directory }
  end
end