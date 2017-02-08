#Test
require 'serverspec'
set :backend, :exec

describe 'ntp-client' do
	describe package('ntp') do
		it { should be_installed }
	end
	describe file('/etc/ntp.conf') do
		it { should be_a_file }
		it { should be_mode 644 }
  end
	if['amazon', 'centos'].include?(os[:family])
		describe service('ntpd') do
			it { should be_running }
			it { should be_enabled }
		end
		describe command('ntpstat') do
			its(:stdout) { should match /synchronised/ }
		end
	end
	if ['debian', 'ubuntu'].include?(os[:family])
		if os[:release] =='14.04'
			describe service('ntp') do
				it { should be_running }
			end
		end
		if os[:release] == '16.04'
			describe service('ntpd') do
				it { should be_running }
				it { should be_enabled }
			end
		end
	end
end
