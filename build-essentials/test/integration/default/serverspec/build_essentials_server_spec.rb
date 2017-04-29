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
  file('/opt/phenom/buildproperties') do
    it { should be_directory }
  end
end
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
describe 'maven' do
  %w(/usr/local/apache-maven).each do |file_name|
    describe file (file_name) do
      it { should be_symlink }
    end
  end
  describe command('/usr/local/apache-maven/bin/mvn -version') do
    its(:exit_status) { should eq 0 }
  end
end