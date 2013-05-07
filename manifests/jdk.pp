# == Define: java:jdk
#
# Installs Java JDK
#
# === Parameters
#
# [*ensure*]
#   Whether the JDK is installed or not
#
# [*vendor*]
#   The vendor of the JDK, can be 'openjdk' or 'sun'
#
# [*version*]
#   The version of the JDK, can be '6' or '7'
#
# [*default*]
#   Update-alternative to this JRE/JDK
#
define java::jdk(
  $ensure = 'present',
  $vendor = 'openjdk',
  $version = 6,
  $default = true,
) {
  validate_re($ensure, ['present', 'absent'])
  validate_re($vendor, ['openjdk', 'sun'])
  validate_re($version, ['6', '7'])
  validate_bool($default)

  $pkg_name = $::osfamily ? {
    Debian => "${vendor}-${version}-jdk",
    RedHat => "java-1.${version}.0-${vendor}-devel",
  }

  if $vendor == 'sun' and $::osfamily == 'Debian' and $ensure == 'present' {

    # Thanks to Java strange licensing
    file {'/var/cache/debconf/sun-java6-bin.preseed':
      ensure  => present,
      content => 'sun-java6-bin   shared/accepted-sun-dlj-v1-1    boolean true',
    }
    ->
    package {"sun-java${version}-bin":
      ensure       => present,
      responsefile => '/var/cache/debconf/sun-java6-bin.preseed',
      before       => Package[$pkg_name],
    }

  }

  package{$pkg_name:
    ensure => $ensure,
  }

  if $default and $ensure == 'present' {

    $java_alternative_path = $::osfamily ? {
      Debian => "/usr/lib/jvm/java-${version}-${vendor}/jre/bin/java",
      RedHat => "/usr/lib/jvm/jre-1.${version}.0-${vendor}.${::architecture}/bin/java",
    }

    $javac_alternative_path = $::osfamily ? {
      Debian => "/usr/lib/jvm/java-${version}-${vendor}/bin/javac",
      RedHat => "/usr/lib/jvm/java-1.${version}.0-${vendor}.${::architecture}/bin/javac",
    }

    # On Debian/Ubuntu status of update-java-alternatives is always 1,
    # || true is a dirty workaround to stop puppet from thinking it failed!
    # Update: this seems to work on Debian 6+
    exec {'set default java':
      command => "update-alternatives --set java ${java_alternative_path}",
      unless  => "test $(readlink /etc/alternatives/java) = ${java_alternative_path}",
      require => Package[$pkg_name],
    }

    exec {'set default javac':
      command => "update-alternatives --set javac ${javac_alternative_path}",
      unless  => "test $(readlink /etc/alternatives/javac) = ${javac_alternative_path}",
      require => Package[$pkg_name],
    }

    if $::osfamily == 'Debian' {

      $keytool_alternative_path = "/usr/lib/jvm/java-${version}-${vendor}/jre/bin/keytool"

      exec {'set default keytool':
        command => "update-alternatives --set keytool ${keytool_alternative_path}",
        unless  => "test $(readlink /etc/alternatives/keytool) = ${keytool_alternative_path}",
        require => Package[$pkg_name],
      }
    }

  }

}
