require 'serverspec'
set :backend, :exec
describe 'nodejs' do
  describe command('npm -v') do
    its(:exit_status) { should eq 0 }
  end
  describe command('node -v') do
    its(:exit_status) { should eq 0 }
  end
  describe command ('gulp -v') do
    its(:exit_status) { should eq 0 }
  end
  describe command ('ng -V') do
    its(:exit_status ) { should eq 0 }
  end
end
