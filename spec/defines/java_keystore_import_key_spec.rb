require 'spec_helper'

describe 'java::keystore::import::key' do
  let (:title) { 'foo' }

  context 'when pkey is empty' do
    let (:params) { {
      :cert      => 'baz',
      :pkey_pass => 'changeit',
    } }

    it 'should fail' do
      expect {should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass pkey/)
    end
  end

  context 'when cert is empty' do
    let (:params) { {
      :pkey      => 'bar',
      :pkey_pass => 'changeit',
    } }

    it 'should fail' do
      expect {should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass cert/)
    end
  end

  context 'when pkey_pass is empty' do
    let (:params) { {
      :pkey => 'bar',
      :cert => 'baz',
    } }

    it 'should fail' do
      expect {should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass pkey_pass/)
    end
  end

  context 'when ensure equals present' do
    let (:params) { {
      :ensure    => 'present',
      :pkey      => 'bar',
      :cert      => 'baz',
      :pkey_pass => 'changeit',
    } }

    it { should contain_exec('Import foo key in ${JAVA_HOME}/jre/lib/security/cacerts').with(
        :command => 'keytool -importkeystore -srckeystore /var/cache/java_keys/foo.p12 -srcstoretype pkcs12 -srcstorepass changeit -srcalias foo -destkeystore ${JAVA_HOME}/jre/lib/security/cacerts -deststoretype jks -deststorepass changeit',
        :unless  => 'keytool -list -keystore ${JAVA_HOME}/jre/lib/security/cacerts -alias foo'
      )
    }
  end

  context 'when override params and ensure equals present' do
    let (:params) { {
      :ensure    => 'present',
      :pkey      => 'bar',
      :cert      => 'baz',
      :pkey_pass => 'changeit',
      :keystore  => 'qux',
      :storepass => 'changeme',
    } }

    it { should contain_exec('Import foo key in qux').with(
        :command => 'keytool -importkeystore -srckeystore /var/cache/java_keys/foo.p12 -srcstoretype pkcs12 -srcstorepass changeit -srcalias foo -destkeystore qux -deststoretype jks -deststorepass changeme',
        :unless  => 'keytool -list -keystore qux -alias foo'
      )
    }
  end

  context 'when ensure equals absent' do
    let (:params) { {
      :ensure    => 'absent',
      :pkey      => 'bar',
      :cert      => 'baz',
      :pkey_pass => 'changeit',
    } }

    it { should contain_exec('Remove foo key from ${JAVA_HOME}/jre/lib/security/cacerts').with(
        :command => 'keytool -delete -keystore ${JAVA_HOME}/jre/lib/security/cacerts -alias foo -storepass changeit',
        :onlyif  => 'keytool -list -keystore ${JAVA_HOME}/jre/lib/security/cacerts -alias foo'
      )
    }

  end

  context 'when override params and ensure equals absent' do
    let (:params) { {
      :ensure    => 'absent',
      :pkey      => 'bar',
      :cert      => 'baz',
      :pkey_pass => 'changeit',
      :keystore  => 'qux',
      :storepass => 'changeme',
    } }

    it { should contain_exec('Remove foo key from qux').with(
        :command => 'keytool -delete -keystore qux -alias foo -storepass changeme',
        :onlyif  => 'keytool -list -keystore qux -alias foo'
      )
    }

  end

end
