class sonarqube {
  require java, mysql

  $install_path = "/opt/sonarqube"

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

#  file {"file-get-sonarqube":
#    path => "/home/vagrant/sonarqube.zip",
#    source => "puppet:///modules/sonarqube/sonarqube-4.1.1.zip",
#    require => Exec["stop-sonarqube"]
#  }

  package {"unzip":
    ensure => present
  }

  file {"${install_path}":
    ensure => "directory"
  }

  exec {"unzip-sonarqube":
    command => "unzip /home/vagrant/sonarqube.zip",
    cwd => "${install_path}",
    require => [Exec["get-sonarqube"], Package["unzip"], File["${install_path}"], Exec["clean-liferay"]],
    path => ["/usr/bin", "/bin"],
  }

  file {"sonarqube.properties":
    path => "${install_path}/conf/sonar.properties",
    source => "puppet:///modules/sonarqube/sonar.properties",
    require => Exec["unzip-sonarqube"]
  }

  exec {"start-sonarqube":
    command => "${install_path}/bin/linux-x86-64/sonar.sh start",
    onlyif => "test -f ${install_path}/bin/linux-x86-64/sonar.sh",
    path => ["/usr/bin", "/bin"],
    require => File["sonarqube.properties"]
  }
}