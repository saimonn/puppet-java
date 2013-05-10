# == Class: java::jvm
#
# Installs Java JDK and sets default JVM
#
# === Parameters
#
# [*default_version*]
#   Set Java default version
#
# [*default_vendor*]
#   Set Java default vendor
#
class java::jvm(
  $default_version = 6,
  $default_vendor = 'openjdk',
) {
  Java::Jdk <| |> -> Exec <| tag == 'java-alternative' |>

  java::jdk{'default JDK':
    ensure  => 'present',
    version => $default_version,
    vendor  => $default_vendor,
  }

  case $::osfamily {
    Debian: {
      # On Debian we use update-java-alternatives
      $java_alternative_path = "/usr/lib/jvm/java-${default_version}-${default_vendor}"
      exec{"update-java-alternatives --set ${java_alternative_path}":
        unless => "test $(readlink /etc/alternatives/java) = ${java_alternative_path}/jre/bin/java",
        tag    => 'java-alternative',
      }
    }
    RedHat: {
      # On Redhat we use update-alternative using 'slave' alternative feature
      $java_alternative_path = "/usr/lib/jvm/jre-1.${default_version}.0-${default_vendor}.${::architecture}/bin/java"
      exec{"update-alternatives --set java ${java_alternative_path}":
        unless => "test $(readlink /etc/alternatives/java) = ${java_alternative_path}",
        tag    => 'java-alternative',
      }
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

}
