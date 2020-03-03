# This guide is optimized for Vagrant 1.7 and above.
# Although versions 1.6.x should behave very similarly, it is recommended
# to upgrade instead of disabling the requirement below.
Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|

  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end

  config.vm.network "forwarded_port", guest: 1094, host: 1094
  config.vm.network "forwarded_port", guest: 9000, host: 9000

  # Disable the new default behavior introduced in Vagrant 1.7, to
  # ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/hashicorp/vagrant/issues/5005
  config.ssh.insert_key = false

  #config.vm.provision "shell", path: "scripts/prepare.sh"
  config.vm.provision "shell", path: "scripts/prepare_escape.sh"

  #config.vm.provision "file", source: "config/xrootd-escape/xrootd-escape.cfg", destination: "/tmp/xrootd-escape.cfg"

  #config.vm.provision "shell",
  #  inline: "sudo cp /tmp/xrootd-escape.cfg /etc/xrootd/"

end