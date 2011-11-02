/*

=Definition: java::key

Creates (or delete) a keypair from a java keystore.

Args:
  $keystore         - keystore filename (mandatory)
  $basedir          - keystore location (mandatory)
  $keyalg           - key algorithm (default: RSA)
  $keysize          - key size (default: 2048)
  $storepass        - keystore password (default: changeit)
  $alias            - key pair alias (default: $name)
  $validity         - key pair validity (default: 365 days)
  $commonName       - key pair common name (default: localhost)
  $organisationUnit - key pair organisation unit (default: na)
  $organisation     - key pair organisation (default: na)
  $country          - key pair country (default: CH)
  keypass           - private key password (default: changeit)


Note: keytool will update an existing keystore!

*/
define java::key($ensure=present,
                 $keystore,
                 $basedir,
                 $keyalg='RSA',
                 $keysize=2048,
                 $storepass='changeit',
                 $kalias='',
                 $validity=365,
                 $commonName='localhost',
                 $organisationUnit='na',
                 $organisation='na',
                 $country='CH',
                 $keypass='changeit'
                 ) {

  $_kalias = $kalias ? {
    '' => $name,
    default => $kalias,
  }

  case $ensure {
    present: {
      $dn = "cn=${commonName}, ou=${organisationUnit}, o=${organisation}, c=${country}"
      exec {"java::key: Creates ${_kalias} to ${keystore}":
        command => "keytool -genkeypair -keyalg ${keyalg} -keysize ${keysize} -keystore ${basedir}/${keystore} -storepass ${storepass} -storetype jks -alias ${_kalias} -validity ${validity} -dname '${dn}' -keypass ${keypass}",
        unless  => "keytool -list -keystore ${basedir}/${keystore} -storepass ${storepass} -alias ${_kalias}"
      }

      exec {"java::key: Export $__kalias keypair":
        command => "keytool -exportcert -keystore ${keystore} -storepass ${storepass} -alias ${_kalias} -file ${basedir}/${_kalias}.crt",
        creates => "${basedir}/${_kalias}.crt",
        require => Exec["java::key: Creates ${_kalias} to ${keystore}"],
      }

      exec {"java::key: Generate CSR for ${_kalias}":
        command => "keytool -certreq -keystore ${keystore} -storepass ${storepass} -alias ${_kalias} -keypass ${keypass} -file ${basedir}/${_kalias}.csr",
        creates => "${basedir}/${_kalias}.csr",
        require => Exec["java::key: Creates ${_kalias} to ${keystore}"],
      }

    }
    absent: {
      exec {"java::key: Remove ${_kalias} from ${keystore}":
        command => "keytool -delete -alias ${_kalias} -keystore ${basedir}/${keystore} -storepass ${storepass}",
        onlyif  => "keytool -lit -keystore ${keystore} -storepass ${storepass} -alias ${_kalias}",
      }
      file {["${basedir}/${_kalias}.csr", "${basedir}/${_kalias}.crt"]:
        ensure => absent,
      }
    }
  }
}
