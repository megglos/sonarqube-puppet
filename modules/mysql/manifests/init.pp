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

  $password = "admin"

  exec {"mysql-passwd":
    unless => "mysqladmin -uroot -p${password} status",
    command => "mysqladmin -uroot password ${password}",
    path => ["/usr/bin", "/bin"],
    require => Service["mysql"]
  }

}