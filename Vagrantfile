# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu14.04"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/20140422/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.define "sonarqubeserver" do |sonarqubeserver|
  end

  config.vm.hostname = "sonarqubeserver"

  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id,
        "--name", "sonarqubeserver",
        "--memory", "1024"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "base.pp"
    puppet.module_path = "modules"
  end

  config.vm.network "public_network", :bridge => 'eth0'

end
