# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # config.vm.box = "ubuntu14.04"
  # config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/20140422/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box = "phusion/ubuntu-14.04-amd64"

  config.vm.define "sonarqubeserver" do |sonarqubeserver|
  end

  config.vm.hostname = "sonarqubeserver"

  if Vagrant.has_plugin?("vagrant-proxyconf")
    puts "find proxyconf plugin !"
    if ENV["http_proxy"]
      puts "http_proxy: " + ENV["http_proxy"]
      config.proxy.http     = ENV["http_proxy"]
    end
    if ENV["https_proxy"]
      puts "https_proxy: " + ENV["https_proxy"]
      config.proxy.https    = ENV["https_proxy"]
    end
    if ENV["no_proxy"]
      config.proxy.no_proxy = ENV["no_proxy"]
    end
  end

  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id,
        "--name", "sonarqubeserver",
        "--memory", "4096"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "base.pp"
    puppet.module_path = "modules"
  end

  #config.vm.network "forwarded_port", guest: 9000, host: 9100
  #config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "private_network", ip: "192.168.56.56"

end
