# -*- mode: ruby -*-
# vi: set ft=ruby :

WORKER_NAME_PREFIX = "flinkworker"
MASTER_NAME = "flinkmaster"
MASTER_IP = "192.168.10.100"
WORKER_IP_TEMPLATE = "192.168.10.%d"
NUMBER_OF_WORKER_INSTANCES = 3
VAGRANTFILE_API_VERSION = "2"

def workername(i)
  workername = "%s-%02d" % [WORKER_NAME_PREFIX, i]
  return workername
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # set up flink master
  config.vm.define(MASTER_NAME, autostart: false) do |master|
      master.vm.box = "ubuntu/trusty64"
      master.vm.hostname = MASTER_NAME
      master.vm.network "private_network", ip: MASTER_IP

      master.vm.provider :virtualbox do |vb|
        vb.name = $master_name
        vb.memory = 2048
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
        vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      end

      master.vm.provision "shell", path: "scripts/setup-os.sh", privileged:false
      master.vm.provision "shell", path: "scripts/setup-java.sh", privileged:false

      master.vm.provision "shell" do |s|
                s.path = "scripts/setup-flink.sh"
                s.args = " -t #{NUMBER_OF_WORKER_INSTANCES}"
                s.privileged=false
      end

      # Set up passwordless ssh
      master.vm.provision "shell" do |s|
              s.path = "scripts/setup-ssh.sh"
              s.args = "#{NUMBER_OF_WORKER_INSTANCES}"
              s.privileged=false
      end

      # start flink cluster
      master.vm.provision "shell", path: "scripts/start-flink-cluster.sh", privileged:false

      master.vm.network "forwarded_port", guest: 8080, host: 8080
      master.vm.network "forwarded_port", guest: 8081, host: 8081
      master.vm.network "forwarded_port", guest: 6123, host: 6123
      master.vm.network "forwarded_port", guest: 22, host: 2220, id: 'ssh'
  end

  # set up flink workers
  (1..NUMBER_OF_WORKER_INSTANCES).each do |i|
   vm_name = "%s-%02d" % [WORKER_NAME_PREFIX, i]
   vm_static_ip = WORKER_IP_TEMPLATE % [100 + i]
   vm_ssh_host_port = "222%01d" % [i]

   config.vm.define(vm_name) do |worker|
    worker.vm.box = "ubuntu/trusty64"

    worker.vm.hostname = vm_name
    worker.vm.network "private_network", ip: vm_static_ip

    worker.vm.provider :virtualbox do |vb|
      vb.name = vm_name
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    end

    worker.vm.provision "shell", path: "scripts/setup-os.sh", privileged:false
    worker.vm.provision "shell", path: "scripts/setup-java.sh", privileged:false

    worker.vm.provision "shell" do |s|
              s.path = "scripts/setup-flink.sh"
              s.args = " -t #{NUMBER_OF_WORKER_INSTANCES}"
              s.privileged=false
    end

    worker.vm.network "forwarded_port", guest: 22, host: vm_ssh_host_port, id: 'ssh'

   end
  end
end
