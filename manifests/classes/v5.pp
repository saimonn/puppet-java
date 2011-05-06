class java::v5 {

  case $java15_vendor {
    bea: {
      $java_pkgname = "java-1.5.0-bea"
    }
    ibm: {
      $java_pkgname = "java-1.5.0-ibm"
    }
    default: {
      $java_pkgname = "java-1.5.0-sun"
    }
  }

  package{ "${java_pkgname}":
    alias => "java-1.5",
    ensure => present,
  }

  package{ "${java_pkgname}-devel":
    alias => "java-1.5-devel",
    ensure => present,
  }
}

