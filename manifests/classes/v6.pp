#
class java::v6 {

  case $java16_vendor {
    bea: {
      $java_pkgname = "java-1.6.0-bea"
    }
    ibm: {
      $java_pkgname = "java-1.6.0-ibm"
    }
    sun: {
      $java_pkgname = $operatingsystem ? {
        RedHat => "java-1.6.0-sun",
        Debian => "sun-java6-jdk",
      }

      if $operatingsystem == "Debian" {

        # Thanks to Java strange licensing
        file {"/var/cache/debconf/sun-java6-bin.preseed":
          ensure  => present,
          content => "sun-java6-bin   shared/accepted-sun-dlj-v1-1    boolean true",
        }

        package { "sun-java6-bin":
          ensure => present,
          responsefile => "/var/cache/debconf/sun-java6-bin.preseed",
          require => File["/var/cache/debconf/sun-java6-bin.preseed"],
          before => Package["sun-java6-jdk"],
        }

        # On Debian/Ubuntu status of update-java-alternatives is always 1,
        # || true is a dirty workaround to stop puppet from thinking it failed!
        exec {"set default jvm":
          command => "update-alternatives --set java /usr/lib/jvm/java-6-sun/jre/bin/java || true",
          unless => 'test $(readlink /etc/alternatives/java) = /usr/lib/jvm/java-6-sun/jre/bin/java',
          require => Package["sun-java6-bin"],
        }

        $jvm = '6'
        file {"/etc/profile.d/java_home":
          ensure => present,
          content => template("java/java-home.erb"),
        }
 
      }
    }
    default: {
      $java_pkgname = $operatingsystem ? {
        RedHat => "java-1.6.0-openjdk",
        Debian => "openjdk-6-jdk",
      }
    }
  }

  package{ "${java_pkgname}":
    alias => "java-1.6",
    ensure => present,
  }

  if $operatingsystem == "RedHat" {
    package{ "${java_pkgname}-devel":
      alias => "java-1.6-devel",
      ensure => present,
    }
  }

}
