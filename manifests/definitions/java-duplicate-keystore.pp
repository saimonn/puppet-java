/*

=Definition: java::duplicate::keystore

Duplicate a java keystore, and set a new password on this one.

Args:
  $srcKeystore  - source keystore
  $basedir      - directory where you want to put the new keystore. Has to exists
  $srcStorepass - source keystore password (default:changeit)
  $destStorepass - new keystore password (default: changeit)

*/
define java::duplicate::keystore ($ensure=present,
                                  $srcKeystore,
                                  $basedir,
                                  $srcStorepass='changeit',
                                  $destStorepass='changeit'
                                  ) {

  case $ensure {
    present: {
      exec {"Duplicate ${srcKeystore} to ${destKeystore}":
        command => "keytool -importkeystore -srckeystore ${srcKeystore} -destkeystore ${basedir}/${name} -srcstorepass ${srcStorepass} -deststorepass ${destStorepass}",
        creates => "${basedir}/${name}",
      }
    }
    absent: {
      file {"${basedir}/${name}":
        ensure => absent,
      }
    }
  }
}
