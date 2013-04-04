require 'spec_helper'

describe 'java::keystore::import' do
  let (:title) { 'foo' }

  context 'when srcKeystore is empty' do
    let (:params) { {
      :basedir       => 'baz',
      :destStorepass => 'qux',
    } }

    it 'should fail' do
      expect { should contain_exec('foo')}.to raise_error(Puppet::Error, /Must pass srcKeystore/)
    end
  end

  context 'when basedir is empty' do
    let (:params) { {
      :srcKeystore   => 'bar',
      :destStorepass => 'qux',
    } }

    it 'should fail' do
      expect { should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass basedir/)
    end
  end

  context 'when destStorepass is empty' do
    let (:params) { {
      :srcKeystore   => 'bar',
      :basedir       => 'baz',
    } }

    it 'should fail' do
      expect { should contain_exec('foo') }.to raise_error(Puppet::Error, /Must pass destStorepass/)
    end
  end

  context 'when ensure equals present' do
    let (:params) { {
      :ensure        => 'present',
      :srcKeystore   => 'bar',
      :basedir       => 'baz',
      :destStorepass => 'qux',
    } }

    it { should contain_exec('Duplicate bar to baz/foo').with(
        :command => 'keytool -importkeystore -srckeystore bar -destkeystore baz/foo -srcstorepass changeit -deststorepass qux',
        :creates => 'baz/foo'
      )
    }
  end

  context 'when override params and ensure equals present' do
    let (:params) { {
      :srcKeystore   => 'bar',
      :basedir       => 'baz',
      :srcStorepass  => 'changeme',
      :destStorepass => 'qux',
    } }

    it { should contain_exec('Duplicate bar to baz/foo').with(
        :command => 'keytool -importkeystore -srckeystore bar -destkeystore baz/foo -srcstorepass changeme -deststorepass qux',
        :creates => 'baz/foo'
      )
    }
  end

  context 'when ensure equals absent' do
    let (:params) { {
      :ensure        => 'absent',
      :srcKeystore   => 'bar',
      :basedir       => 'baz',
      :destStorepass => 'qux',
    } }

    it { should contain_file('baz/foo').with(:ensure => 'absent') }
  end

end
