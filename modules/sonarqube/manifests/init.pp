class sonarqube {
  require java, mysql

  $install_path = "/opt/sonarqube"
  $sonarqube_path = "sonarqube-4.1.1"

  exec {"stop-sonarqube":
    command => "${install_path}/bin/linux-x86-64/sonar.sh stop",
    onlyif => "test -f ${install_path}/bin/linux-x86-64/sonar.sh",
    path => ["/usr/bin", "/bin"],
  }

  exec {"clean-sonarqube":
    command => "rm -fR ${install_path}/*",
    path => ["/usr/bin", "/bin"],
    require => Exec["stop-sonarqube"]
  }

  package {"wget":
    ensure => present
  }

  exec {"get-sonarqube":
    command => "wget http://dist.sonar.codehaus.org/sonarqube-4.1.1.zip -O /home/vagrant/sonarqube.zip",
    cwd => "/home/vagrant",
    path => ["/usr/bin", "/bin"],
    require => Package["wget"],
    timeout => 600
  }

  package {"unzip":
    ensure => present
  }

  file {"${install_path}":
    ensure => "directory"
  }

  exec {"unzip-sonarqube":
    command => "unzip /home/vagrant/sonarqube.zip",
    cwd => "${install_path}",
    require => [Exec["get-sonarqube"], Package["unzip"], File["${install_path}"], Exec["clean-sonarqube"]],
    path => ["/usr/bin", "/bin"],
  }

  file {"sonarqube.properties":
    path => "${install_path}/${sonarqube_path}/conf/sonar.properties",
    source => "puppet:///modules/sonarqube/sonar.properties",
    require => Exec["unzip-sonarqube"]
  }

  $l_db = "sonar"
  $l_user = "sonar"
  $l_pass = "sonar"
  $password = "admin"

  exec {"create-sonarqube-db":
    unless => "mysql -u${l_user} -p${l_pass} ${l_db}",
    command => "mysql -uroot -p${password} -e \"create database ${l_db}; grant all on ${l_db}.* to ${l_user}@'localhost' identified by '${l_pass}'; grant all on ${l_db}.* to ${l_user}@'%' identified by '${l_pass}';flush privileges;\"",
    path => ["/usr/bin", "/bin"],
    require => File["sonarqube.properties"]
  }

  exec {"start-sonarqube":
    command => "${install_path}/${sonarqube_path}/bin/linux-x86-64/sonar.sh start",
    onlyif => "test -f ${install_path}/${sonarqube_path}/bin/linux-x86-64/sonar.sh",
    path => ["/usr/bin", "/bin"],
    require => Exec["create-sonarqube-db"]
  }
}