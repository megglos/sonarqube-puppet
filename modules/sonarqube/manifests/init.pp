class sonarqube {
  require java, mysql


  $install_path = "/opt/sonarqube"
  $sonar_version = "5.2"
  $sonarqube_path = "${install_path}/sonarqube-${sonar_version}"  

  exec {"stop-sonarqube":
    command => "${sonarqube_path}/bin/linux-x86-64/sonar.sh stop",
    onlyif => "test -f ${sonarqube_path}/bin/linux-x86-64/sonar.sh",
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

  #exec {"get-sonarqube":
  #  command => "wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${sonar_version}.zip -O /home/vagrant/sonarqube.zip",
  #  cwd => "/home/vagrant",
  #  path => ["/usr/bin", "/bin"],
  #  require => Package["wget"],
  #  timeout => 600
  #}
  exec {"get-sonarqube":
    command => "/bin/cp /vagrant/modules/sonarqube/files/sonarqube-${sonar_version}.zip /home/vagrant/sonarqube.zip",
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

  exec {"install-findbugs-plugin":
    command => "wget https://sonarsource.bintray.com/Distribution/sonar-findbugs-plugin/sonar-findbugs-plugin-3.3.jar",
    cwd => "${sonarqube_path}/extensions/plugins",
    require => [Exec["unzip-sonarqube"], Package["wget"]],
    path => ["/usr/bin", "/bin"],
    timeout => 600
  }

  exec {"install-pmd-plugin":
    command => "wget https://sonarsource.bintray.com/Distribution/sonar-pmd-plugin/sonar-pmd-plugin-2.5.jar",
    cwd => "${sonarqube_path}/extensions/plugins",
    require => [Exec["unzip-sonarqube"], Package["wget"]],
    path => ["/usr/bin", "/bin"],
    timeout => 600
  }

  exec {"install-checkstyle-plugin":
    command => "wget http://sonarsource.bintray.com/Distribution/sonar-checkstyle-plugin/sonar-checkstyle-plugin-2.4.jar",
    cwd => "${sonarqube_path}/extensions/plugins",
    require => [Exec["unzip-sonarqube"], Package["wget"]],
    path => ["/usr/bin", "/bin"],
    timeout => 600
  }

  file {"install-gerrit-plugin":
    path => "${sonarqube_path}/extensions/plugins/sonar-gerrit-plugin-2.3.0-SNAPSHOT.jar",
    source => "puppet:///modules/sonarqube/files/sonar-gerrit-plugin-2.3.0-SNAPSHOT.jar",
  }

  file {"sonarqube.properties":
    path => "${sonarqube_path}/conf/sonar.properties",
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
    command => "${sonarqube_path}/bin/linux-x86-64/sonar.sh start",
    onlyif => "test -f ${sonarqube_path}/bin/linux-x86-64/sonar.sh",
    path => ["/usr/bin", "/bin"],
    require => Exec["create-sonarqube-db"]
  }
}