require 'serverspec'
set :backend, :exec
describe 'mysql' do
  case os[:family]
    when 'ubuntu'
      package_names =%w(mysql-client mysql-server)
      service_name='mysql'
    when 'redhat'
      package_names =%w(mariadb-server mariadb)
      service_name='mariadb'
  end
  package_names.each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
  describe port (3306) do
    it { should be_listening }
  end
end
