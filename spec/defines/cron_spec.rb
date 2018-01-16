require 'spec_helper'

describe 'logrotate::cron' do
  _, facts = on_supported_os.first
  let(:facts) { facts }
  let(:pre_condition) { 'class {"::logrotate": }' }

  context 'Default params' do
    let(:title) { 'test' }
    let(:params) { { ensure: 'present' } }
    let(:facts) { { osfamily: 'RedHat' } }

    it {
      is_expected.to contain_file('/etc/cron.test/logrotate').
        with_ensure('present').
        with_content(%r{(\/usr\/sbin\/logrotate \/etc\/logrotate.conf 2>&1)})
    }
  end

  context 'Default params (FreeBSD)' do
    let(:title) { 'test' }
    let(:params) { { ensure: 'present' } }
    let(:facts) { { osfamily: 'FreeBSD' } }

    it {
      is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
        with_ensure('present').
        with_content(%r{(\/usr\/local\/sbin\/logrotate \/usr\/local\/etc\/logrotate.conf 2>&1)})
    }
  end

  context 'With additional arguments' do
    let(:pre_condition) { 'class {"::logrotate": logrotate_args => ["-s /var/lib/logrotate/logrotate.status", "-m /usr/sbin/mailer"]}' }
    let(:title) { 'test' }
    let(:params) { { ensure: 'present' } }
    let(:facts) { { osfamily: 'RedHat' } }

    it {
      is_expected.to contain_file('/etc/cron.test/logrotate').
        with_content(%r{(\/usr\/sbin\/logrotate -s \/var\/lib\/logrotate\/logrotate.status -m \/usr\/sbin\/mailer \/etc\/logrotate.conf 2>&1)})
    }
  end
end
