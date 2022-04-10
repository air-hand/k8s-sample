# -*- mode: ruby -*-
# vi: set ft=ruby :
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

require 'yaml'

ANSIBLE_INVENTORY_PATH = 'provision/hosts.yml'

begin
  conf = YAML.load_file(File.join(File.dirname(__FILE__), ANSIBLE_INVENTORY_PATH))
end

Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com.
  config.vm.box = "debian/bullseye64"
  config.vagrant.plugins = {
    "vagrant-env" => {},
    "vagrant-vbguest" => {"version" => "0.26.0"},
    "virtualbox_WSL2" => {},
  }

  config.env.enable

  config.vbguest.auto_update = false
  config.vbguest.auto_reboot = true
  config.vbguest.installer_options = {
      allow_kernel_upgrade: true
  }
  config.vbguest.no_remote = false

  conf['all']['hosts'].each.with_index do |(host, val), index|
    config.vm.define host do |machine|
      machine.vm.hostname = host
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-#{host}"
        vb.linked_clone = true
        if host == 'ansible-controller'
          vb.memory = 1024
          vb.cpus = 1
          vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        else
          # minimum requirements for k8s
          vb.memory = 2048
          vb.cpus = host == 'control-plane' ? 3 : 2
        end
      end
      machine.vm.synced_folder ".", "/vagrant", owner: "vagrant", mount_options: ["dmode=700,fmode=600"]
      machine.vm.network "private_network", ip: val['ip']

      if host == 'ansible-controller'
        # install k8s by ansible.
        machine.vm.provision "shell", preserve_order: true, inline: <<-SHELL
          apt-get update -y
          apt-get install -y python3 python3-distutils python3-venv python3-firewall
          python3 -m venv /ansible --system-site-packages
          /ansible/bin/pip install -U pip wheel
          /ansible/bin/pip install -r /vagrant/provision/requirements.txt
          chown -R vagrant:vagrant /ansible
          mkdir -p /ansible/roles
          cd /vagrant/provision
          /ansible/bin/ansible-galaxy install -r galaxy_requirements.yml --force
          /ansible/bin/ansible-playbook -i hosts.yml playbook.yml -v
        SHELL
      end
    end
  end
end

