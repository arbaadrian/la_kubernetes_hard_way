# -*- mode: ruby -*-
# vi: set ft=ruby :

#### Variables

box = "centos/7"
cpus = 2

#### Code

Vagrant.configure("2") do |config|

  config.vm.define "kubernetes-api" do |ka|
    ka.vm.box = box
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
    ka.vm.provision "shell", :path => "general_provision.sh"
    ka.vm.provision "shell", :path => "api_certificates.sh"
  end

  (1..2).each do |i|
    config.vm.define "kubernetes-worker-#{i}" do |kw|
      kw.vm.box = box
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
      kw.vm.provision "shell", :path => "general_provision.sh"
    end
  end

  (1..2).each do |i|
    config.vm.define "kubernetes-controller-#{i}" do |kc|
      kc.vm.box = box
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
      kc.vm.provision "shell", :path => "general_provision.sh"
      kc.vm.provision "shell", :path => "controller_etcd.sh"
    end
  end

end