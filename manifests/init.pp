class java {
  case $::operatingsystem {
    Debian,Ubuntu,RedHat,CentOS: { include java::v6 }
    default: { notice "Unsupported operatingsystem ${::operatingsystem}" }
  }
}
