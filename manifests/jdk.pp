# == Define: java::jdk
#
# Installs Java JDK
#
# === Parameters
#
# [*ensure*]
#   Whether the JDK is installed or not
#
# [*version*]
#   The version of the JDK, can be '6' or '7'
#
# [*vendor*]
#   The vendor of the JDK, can be 'openjdk' or 'sun'
#
define java::jdk(
  $ensure = 'present',
  $version = 6,
  $vendor = 'openjdk',
) {
  validate_re($ensure, ['present', 'absent'])

  case $::osfamily {
    Debian: {
      case $::operatingssytem {
        Debian: {
          if $::lsbdistrelease <= 5 {
            validate_re($version, [5, 6])
            validate_re($vendor, ['sun'])
          } elsif $::lsbdistrelease <= 6 {
            validate_re($version, [6])
            validate_re($vendor, ['sun', 'openjdk'])
          } else {
            validate_re($version, [6, 7])
            validate_re($vendor, ['openjdk'])
          }
        }
        Ubuntu: {
          if $::lsbdistrelease <= 10.04 {
            validate_re($version, [6])
            validate_re($vendor, ['openjdk'])
          } else {
            validate_re($version, [6, 7])
            validate_re($vendor, ['openjdk'])
          }
        }
        default: {
          fail("unsupported Operating System: ${::operatingsystem}")
        }
      }
      $pkgs = [
        "${vendor}-${version}-jre",
        "${vendor}-${version}-jdk",
      ]

      if $vendor == 'sun' and $ensure == 'present' {
        # Thanks to Java strange licensing
        file {'/var/cache/debconf/sun-java6-bin.preseed':
          ensure  => present,
          content =>
          'sun-java6-bin   shared/accepted-sun-dlj-v1-1    boolean true',
        }
        ->
        package {"sun-java${version}-bin":
          ensure       => present,
          responsefile => '/var/cache/debconf/sun-java6-bin.preseed',
          before       => Package[$pkgs],
        }
      }
    }
    RedHat: {
      case $version {
        6: {
          validate_re($vendor, ['openjdk', 'sun', 'ibm'])
        }
        7: {
          validate_re($vendor, ['openjdk', 'oracle', 'ibm'])
        }
        default: {
          fail("Unsupported JDK version: ${version}")
        }
      }
      $pkgs = [
        "java-1.${version}.0-${vendor}",
        "java-1.${version}.0-${vendor}-devel",
      ]
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

  package{$pkgs:
    ensure => $ensure,
  }

}
