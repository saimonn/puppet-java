require 'spec_helper'

describe 'java::keystore::import::cert' do
  let (:title) { 'foo' }
  let (:params) { {
    :cert => 'bar',
  } }

  it 'should fail' do
    expect {
      should contain_file('foo')
    }.to raise_error(Puppet::Error, /obsolete/)
  end
end
