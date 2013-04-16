require 'spec_helper'

describe 'java::keystore::keypair' do
  let (:title) { 'foo' }

  context 'when keystore is empty' do
    let (:params) { {
      :basedir => 'baz',
      :country => 'CH',
      :organisation => 'c2c',
    } }

    it 'should fail' do
      expect { should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass keystore/)
    end
  end

  context 'when basedir is empty' do
    let (:params) { {
      :keystore => 'bar',
      :country  => 'CH',
      :organisation => 'c2c',
    } }

    it 'should fail' do
      expect { should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass basedir/)
    end
  end

  context 'when keystore, basedir and ensure are set to bar, baz and absent' do
    let (:params) { {
      :ensure       => 'absent',
      :keystore     => 'bar',
      :basedir      => 'baz',
      :country      => 'CH',
      :organisation => 'c2c',
    } }

    it { should contain_openssl__certificate__x509('foo').with(
        :ensure       => 'absent',
        :base_dir     => 'baz',
        :country      => 'CH',
        :organisation => 'c2c',
        :days         => '3650'
      )
    }

    it { should contain_java_ks('foo:baz/bar').with(
        :ensure      => 'absent',
        :certificate => 'baz/foo.crt',
        :private_key => 'baz/foo.key',
        :password    => 'changeit'
      )
    }
  end

  context 'when keystore and basedir are set to bar and baz' do
    let (:params) { {
      :keystore => 'bar',
      :basedir  => 'baz',
      :country      => 'CH',
      :organisation => 'c2c',
    } }

    it { should contain_openssl__certificate__x509('foo').with(
        :ensure       => 'present',
        :base_dir     => 'baz',
        :country      => 'CH',
        :organisation => 'c2c',
        :days         => '3650'
      )
    }

    it { should contain_java_ks('foo:baz/bar').with(
        :ensure      => 'present',
        :certificate => 'baz/foo.crt',
        :private_key => 'baz/foo.key',
        :password    => 'changeit'
      )
    }
  end

  context 'when passing keyalg' do
    let (:params) { {
      :keystore     => 'bar',
      :basedir      => 'baz',
      :organisation => 'example',
      :country      => 'com',
      :keyalg       => 'RSA',
    } }

    it 'should fail' do
      expect {
        should contain_java_ks('foo:baz/bar')
      }.to raise_error(Puppet::Error, /\$keyalg is deprecated/)
    end
  end

  context 'when passing keysize' do
    let (:params) { {
      :keystore     => 'bar',
      :basedir      => 'baz',
      :organisation => 'example',
      :country      => 'com',
      :keysize      => '1024',
    } }

    it 'should fail' do
      expect {
        should contain_java_ks('foo:baz/bar')
      }.to raise_error(Puppet::Error, /\$keysize is deprecated/)
    end
  end

  context 'when override params' do
    let (:params) { {
      :keystore         => 'bar',
      :basedir          => 'baz',
      :storepass        => 'changeme',
      :kalias           => 'qux',
      :validity         => 365,
      :commonName       => 'myhost',
      :organisationUnit => 'it',
      :organisation     => 'example',
      :country          => 'com',
      :keypass          => 'changeme',
    } }

    it { should contain_openssl__certificate__x509('qux').with(
        :ensure       => 'present',
        :base_dir     => 'baz',
        :country      => 'com',
        :organisation => 'example',
        :unit         => 'it',
        :commonname   => 'myhost',
        :days         => '365'
      )
    }

    it { should contain_java_ks('qux:baz/bar').with(
        :ensure      => 'present',
        :certificate => 'baz/qux.crt',
        :private_key => 'baz/qux.key',
        :password    => 'changeme'
      )
    }
  end

end
