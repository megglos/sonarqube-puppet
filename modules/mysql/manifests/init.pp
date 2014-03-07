class mysql {
  require apt-update

  package {
    ["mysql-server", "mysql-client"]:
    ensure => installed
  }

  service {"mysql":
    ensure => running,
    enable => true,
    require => Package["mysql-server"]
  }

  $password = "eivnc7UCo2"

  exec {"mysql-passwd":
    unless => "mysqladmin -uroot -p${password} status",
    command => "mysqladmin -uroot password ${password}",
    path => ["/usr/bin", "/bin"],
    require => Service["mysql"]
  }

  $l_db = "sonar"
  $l_user = "sonar"
  $l_pass = "sonar"

  exec {"create-sonar-db":
    unless => "mysql -u${l_user} -p${l_pass} ${l_db}",
    command => "mysql -uroot -p${password} -e \"create database ${l_db};grant all on ${l_db}.* to ${l_user}@'localhost' identified by '${l_pass}'; flush privileges;\"",
    path => ["/usr/bin", "/bin"],
    require => Exec["mysql-passwd"]
  }

}