require 'spec_helper'

describe 'java::keystore::import::cert' do
  let (:title) { 'foo' }

  context 'when cert is empty' do
    it 'should fail' do
      expect {should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass cert/)
    end
  end

  context 'when ensure equals present' do
    let (:params) { {
      :ensure => 'present',
      :cert   => 'bar',
    } }

    it { should contain_exec('Import foo cert in ${JAVA_HOME}/jre/lib/security/cacerts').with(
        :command => 'keytool -importcert -alias foo -file bar -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit -noprompt -trustcacerts',
        :unless  => 'keytool -list -keystore ${JAVA_HOME}/jre/lib/security/cacerts -alias foo'
      )
    }
  end

  context 'when override params and ensure equals present' do
    let (:params) { {
      :ensure    => 'present',
      :cert      => 'bar',
      :keystore  => 'baz',
      :storepass => 'changeme',
    } }

    it { should contain_exec('Import foo cert in baz').with(
        :command => 'keytool -importcert -alias foo -file bar -keystore baz -storepass changeme -noprompt -trustcacerts',
        :unless  => 'keytool -list -keystore baz -alias foo'
      )
    }
  end

  context 'when ensure equals absent' do
    let (:params) { {
      :ensure => 'absent',
      :cert   => 'bar',
    } }

    it { should contain_exec('Remove foo cert from ${JAVA_HOME}/jre/lib/security/cacerts').with(
        :command => 'keytool -delete -keystore ${JAVA_HOME}/jre/lib/security/cacerts -alias foo -storepass changeit',
        :onlyif  => 'keytool -list -keystore ${JAVA_HOME}/jre/lib/security/cacerts -alias foo'
      )
    }
  end

  context 'when override params and ensure equals absent' do
    let (:params) { {
      :ensure => 'absent',
      :cert   => 'bar',
      :keystore  => 'baz',
      :storepass => 'changeme',
    } }

    it { should contain_exec('Remove foo cert from baz').with(
        :command => 'keytool -delete -keystore baz -alias foo -storepass changeme',
        :onlyif  => 'keytool -list -keystore baz -alias foo'
      )
    }
  end
end
