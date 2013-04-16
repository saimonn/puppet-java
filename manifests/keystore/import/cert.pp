# Definition: java::::keystore::import::cert
# Obsoleted by java_ks
#
define java::keystore::import::cert (
  $cert,
  $ensure=present,
  $keystore='${JAVA_HOME}/jre/lib/security/cacerts',
  $storepass='changeit',
) {

  fail "This definition is obsolete. Use `puppetlabs/java_ks` instead:
    java_ks { '${name}:${keystore}':
      ensure      => '${ensure}',
      certificate => '${cert}',
      password    => '${storepass}',
    }
"
}

