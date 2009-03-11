class java::v6 {

  case $lsbdistcodename {
    'etch' : {
      os::backported_package { 
        "sun-java6-bin":    
          ensure       => present,
          responsefile => "/var/cache/debconf/sun-java6-bin.preseed",
          require      => [Exec["apt-get_update"], File["/var/cache/debconf/sun-java6-bin.preseed"]];
        "sun-java6-jdk":    
          ensure  => present,
          require => Package["sun-java6-bin"];
        "sun-java6-jre":    
          ensure  => present,
          require => Package["sun-java6-bin"];
      }
    
      case $architecture {
        amd64: {
          os::backported_package {"sun-java6-plugin":
            ensure  => present,
            require => Package["sun-java6-bin"],
          }
        }
      }

    }
    'lenny' : {
      package { "sun-java6-bin":
        ensure       => present,
        responsefile => "/var/cache/debconf/sun-java6-bin.preseed",
        require      => [Exec["apt-get_update"], File["/var/cache/debconf/sun-java6-bin.preseed"]],
      }
      
      package {["sun-java6-jdk", "sun-java6-jre"]:
        ensure  => present,
        require => Package["sun-java6-bin"],
      }
    } 
  }

  # Thanks to Java strange licensing
  file {"/var/cache/debconf/sun-java6-bin.preseed":
    ensure  => present,
    content => "sun-java6-bin   shared/accepted-sun-dlj-v1-1    boolean true",
  }

  $jvm = '6'
  file {"/etc/profile.d/java_home":
    ensure => present,
    content => template("java/java-home.erb"),
  }
}