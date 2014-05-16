# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "graylog2"
  config.vm.box_url = "http://vagrantboxes.footballradar.com/wheezy64.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file = "graylog2.pp"
    puppet.module_path = "modules"
  end

  config.vm.network :forwarded_port, guest: 9000, host: 9000
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 12201, host: 12201, protocol: 'udp', auto_correct: true
  config.vm.network :forwarded_port, guest: 12201, host: 12201, protocol: 'tcp', auto_correct: true
  config.vm.network :forwarded_port, guest: 12900, host: 12900

end
