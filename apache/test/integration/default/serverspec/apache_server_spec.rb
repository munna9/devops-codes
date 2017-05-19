require 'serverspec'
set :backend, :exec

describe 'apache' do
  case os[:family]
    when 'ubuntu'
      package_names =%w(apache2)
      service_name='apache2'
    when 'redhat', 'amazon'
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