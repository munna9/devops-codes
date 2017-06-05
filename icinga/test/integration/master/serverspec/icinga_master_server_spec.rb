require 'serverspec'
set :backend,:exec
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
describe 'apache' do
  case os[:family]
    when 'ubuntu'
      package_names =%w(apache2)
      service_name='apache2'
    when 'redhat'
      package_names =%w(httpd)
      service_name='httpd'
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
  describe port (80) do
    it { should be_listening }
  end
end
describe 'icinga-master' do
  package_names =%w(icinga2 icingaweb2 nagios-plugins-all )
  service_name="icinga2"
  package_names.each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
  describe port (5665) do
    it { should be_listening }
  end
end