require 'spec_helper'

describe 'java::keystore::import::key' do
  let (:title) { 'foo' }
  let (:params) { {
    :cert => 'bar',
    :pkey => 'baz',
    :pkey_pass => 'booz',
  } }

  it 'should fail' do
    expect {
      should contain_file('foo')
    }.to raise_error(Puppet::Error, /obsolete/)
  end
end
