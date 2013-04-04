require 'spec_helper'

describe 'java::keystore::keypair' do
  let (:title) { 'foo' }

  context 'when keystore is empty' do
    let (:params) { {
      :basedir => 'baz',
    } }

    it 'should fail' do
      expect { should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass keystore/)
    end
  end

  context 'when basedir is empty' do
    let (:params) { {
      :keystore => 'bar',
    } }

    it 'should fail' do
      expect { should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass basedir/)
    end
  end

  context 'when keystore, basedir and ensure are set to bar, baz and absent' do
    let (:params) { {
      :ensure   => 'absent',
      :keystore => 'bar',
      :basedir  => 'baz',
    } }

    it { should contain_exec('java::key: Remove foo from bar').with(
        :command => 'keytool -delete -alias foo -keystore baz/bar -storepass changeit',
        :onlyif  => 'keytool -list -keystore bar -storepass changeit -alias foo'
      )
    }

    it { should contain_file('baz/foo.csr').with(:ensure => 'absent') }
    it { should contain_file('baz/foo.crt').with(:ensure => 'absent') }
  end

  context 'when keystore and basedir are set to bar and baz' do
    let (:params) { {
      :keystore => 'bar',
      :basedir  => 'baz',
    } }

    it { should contain_exec('java::key: Creates foo to bar').with(
        :command => 'keytool -genkeypair -keyalg RSA -keysize 2048 -keystore baz/bar -storepass changeit -storetype jks -alias foo -validity 3650 -dname \'cn=localhost\' -keypass changeit',
        :unless  => 'keytool -list -keystore baz/bar -storepass changeit -alias foo'
      )
    }

    it { should contain_exec('java::key: Export foo keypair').with(
        :command => 'keytool -exportcert -keystore baz/bar -storepass changeit -keypass changeit -alias foo -file baz/foo.crt',
        :creates => 'baz/foo.crt'
      )
    }

    it { should contain_exec('java::key: Generate CSR for foo').with(
        :command => 'keytool -certreq -keystore baz/bar -storepass changeit -alias foo -keypass changeit -file baz/foo.csr',
        :creates => 'baz/foo.csr'
      )
    }

  end

  context 'when override params' do
    let (:params) { {
      :keystore         => 'bar',
      :basedir          => 'baz',
      :keyalg           => 'DSA',
      :keysize          => 1024,
      :storepass        => 'changeme',
      :kalias           => 'qux',
      :validity         => 365,
      :commonName       => 'myhost',
      :organisationUnit => 'it',
      :organisation     => 'example',
      :country          => 'com',
      :keypass          => 'changeme',
    } }

    it { should contain_exec('java::key: Creates qux to bar').with(
        :command => 'keytool -genkeypair -keyalg DSA -keysize 1024 -keystore baz/bar -storepass changeme -storetype jks -alias qux -validity 365 -dname \'cn=myhost,ou=it,o=example,c=com\' -keypass changeme',
        :unless  => 'keytool -list -keystore baz/bar -storepass changeme -alias qux'
      )
    }

    it { should contain_exec('java::key: Export qux keypair').with(
        :command => 'keytool -exportcert -keystore baz/bar -storepass changeme -keypass changeme -alias qux -file baz/qux.crt',
        :creates => 'baz/qux.crt'
      )
    }

    it { should contain_exec('java::key: Generate CSR for qux').with(
        :command => 'keytool -certreq -keystore baz/bar -storepass changeme -alias qux -keypass changeme -file baz/qux.csr',
        :creates => 'baz/qux.csr'
      )
    }

  end

end
