# Definition: java::keystore::import::key
# Obsoleted by java_ks
#
define java::keystore::import::key (
  $ensure='',
  $pkey,
  $cert,
  $pkey_pass,
  $keystore='${JAVA_HOME}/jre/lib/security/cacerts',
  $storepass='changeit',
) {

  fail "This definition is obsolete. Use `puppetlabs/java_ks` instead:
    java_ks { '${name}:${keystore}':
      ensure      => '${ensure}',
      certificate => '${cert}',
      private_key => '${pkey}',
      password    => '${pkey_pass}',
    }
"
}
