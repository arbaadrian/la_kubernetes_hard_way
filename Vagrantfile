# -*- mode: ruby -*-
# vi: set ft=ruby :

#### Variables

box = "centos/7"
ip = "192.168.56.3"
memory = 8192
cpus = 2
disksize = "80GB"

#### Scripts

# General configuration

ssh_public_key = "public key"
ssh_private_key = "-----BEGIN RSA PRIVATE KEY-----
My
Private
Key
-----END RSA PRIVATE KEY-----"

$provision_script = <<-SHELL
yum update -y
yum install -y vim python git gcc wget curl
useradd aarba
mkdir /home/aarba/.ssh
chmod 700 /home/aarba/.ssh
echo "#{ssh_public_key}" > /home/aarba/.ssh/authorized_keys
chmod 600 /home/aarba/.ssh/authorized_keys
chown -R aarba.aarba /home/aarba
echo "aarba ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
SHELL

#### Code

Vagrant.configure("2") do |config|

  (1..2).each do |i|
    config.vm.define "kubernetes-worker-#{i}" do |kw|
      kw.vm.box = "centos/7"
      kw.vm.network "private_network", ip: "192.168.56.#{i + 6}"
      kw.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--natdnshostresolver1', 'on',
          '--memory', '2048',
          '--cpus', cpus,
          '--nictype1', 'virtio',
          '--nictype2', 'virtio'
          ]
      end
      kw.vm.provision :hosts, :add_localhost_hostnames => false
      kw.vm.provision "shell", inline: $provision_script
    end
  end

  (1..2).each do |i|
    config.vm.define "kubernetes-controller-#{i}" do |kc|
      kc.vm.box = "centos/7"
      kc.vm.network "private_network", ip: "192.168.56.#{i + 8}"
      kc.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--natdnshostresolver1', 'on',
          '--memory', '2048',
          '--cpus', cpus,
          '--nictype1', 'virtio',
          '--nictype2', 'virtio'
          ]
      end
      kc.vm.provision :hosts, :add_localhost_hostnames => false
      kc.vm.provision "shell", inline: $provision_script
    end
  end

  config.vm.define "kubernetes-api" do |ka|
    ka.vm.box = "centos/7"
    ka.vm.network "private_network", ip: "192.168.56.11"
    ka.vm.provider :virtualbox do |vb|
      vb.customize [
        'modifyvm', :id,
        '--natdnshostresolver1', 'on',
        '--memory', '2048',
        '--cpus', cpus,
        '--nictype1', 'virtio',
        '--nictype2', 'virtio'
        ]
    end
    ka.vm.provision :hosts, :add_localhost_hostnames => false
    ka.vm.provision "shell", inline: $provision_script
  end

end