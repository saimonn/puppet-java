#
#
# Definition: java::keystore::keypair
#
# Creates (or delete) a keypair from a java keystore.
#
# Args:
#   $name             - key alias in keystore
#   $keystore         - keystore filename (mandatory)
#   $basedir          - keystore location (mandatory)
#   $keyalg           - key algorithm - DEPRECATED
#   $keysize          - key size - DEPRECATED
#   $storepass        - keystore password (default: changeit)
#   $alias            - key pair alias (default: $name)
#   $validity         - key pair validity (default: 3650 days)
#   $commonName       - key pair common name (default: localhost)
#   $organizationUnit - key pair organization unit (default: empty)
#   $organization     - key pair organization (default: empty)
#   $country          - key pair country (default: empty)
#   keypass           - private key password (default: changeit)
#
#
# Notes:
#   - keytool will update an existing keystore!
#   - according to https://issues.apache.org/bugzilla/show_bug.cgi?id=38217 ,
#     storepass and keypass should be the same. As it's not sure it has
#     to be the case in the future, we let you the choice about that.
#
#
define java::keystore::keypair(
  $keystore,
  $basedir,
  $country,
  $organization,
  $ensure=present,
  $keyalg=undef,
  $keysize=undef,
  $storepass='changeit',
  $kalias='',
  $validity=3650,
  $state=undef,
  $locality=undef,
  $commonName='localhost',
  $organizationUnit=undef,
  $email=undef,
  $keypass='changeit',
) {

  $_kalias = $kalias ? {
    ''      => $name,
    default => $kalias,
  }

  if $keyalg {
    fail '$keyalg is deprecated'
  }

  if $keysize {
    fail '$keysize is deprecated'
  }

  openssl::certificate::x509 { $_kalias:
    ensure       => $ensure,
    base_dir     => $basedir,
    country      => $country,
    state        => $state,
    locality     => $locality,
    commonname   => $commonName,
    organization => $organization,
    unit         => $organizationUnit,
    email        => $email,
    days         => $validity,
  }

  java_ks { "${_kalias}:${basedir}/${keystore}":
    ensure      => $ensure,
    certificate => "${basedir}/${_kalias}.crt",
    private_key => "${basedir}/${_kalias}.key",
    password    => $storepass,
  }

  case $ensure {
    'present': {
      Openssl::Certificate::X509[$_kalias] ->
      Java_ks["${_kalias}:${basedir}/${keystore}"]
    }

    'absent': {
      Java_ks["${_kalias}:${basedir}/${keystore}"] ->
      Openssl::Certificate::X509[$_kalias]
    }

    default: {
      fail "\$ensure must be either 'present' or 'absent', got '${ensure}'"
    }
  }
}
