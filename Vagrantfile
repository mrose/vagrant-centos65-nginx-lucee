# -*- mode: ruby -*-
# vi: set ft=ruby :

load 'config'

Vagrant.require_version ">= 1.8.1"

Vagrant.configure("2") do |config|

  # note: the box below already has a group 'apache' and user 'apache' with uid and gid 48
  config.vm.box = "fillup/centos-6.5-x86_64-minimal"
  config.vm.box_check_update = false
  config.vm.network :private_network, ip: PRIVATE_NETWORK_IP
  config.vm.hostname = HOSTNAME

  config.vm.provider :virtualbox do |vb|
    # dynamically determine cpus & memory: https://github.com/nodesource/vagrant-lldb-perf/blob/master/Vagrantfile
      # cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      # MEMORY = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
      # right now MEMORY variable is set in config
    vb.customize ["modifyvm", :id, "--memory", MEMORY]
      # vb.customize ["modifyvm", :id, "--cpus", cpus]
    vb.customize ["modifyvm", :id, "--ioapic", "on" ]
  end

  config.vm.provision "shell", path: "provision/kickstart/kickstart.sh", name: "kickstart"
  config.vm.provision "shell", path: "provision/java/java.sh", name: "java"
  config.vm.provision "shell", path: "provision/tomcat/tomcat.sh", name: "tomcat"
  config.vm.provision "shell", path: "provision/lucee/lucee.sh", name: "lucee"
  config.vm.provision "shell", path: "provision/nginx/nginx.sh", name: "nginx"
  config.vm.provision "shell", path: "provision/postfix/postfix.sh", name: "postfix"
  config.vm.provision "shell", path: "provision/mariadb/mariadb.sh", name: "mariadb"
  config.vm.provision "shell", path: "provision/custom/custom.sh", name: "custom"
  config.vm.provision "shell", path: "provision/iptables/iptables.sh", name: "iptables"

# use ssh tunneling, vpn, or similar:
# http://dnando.github.io/blog/2014/11/04/ssh-tunneling-coldfusion-lockdown-technique/
# http://stackoverflow.com/questions/4216822/work-on-a-remote-project-with-eclipse-via-ssh
# https://github.com/apenwarr/sshuttle/blob/master/README.md

#  SITE = TOMCAT_HOME + '/sites/' + HOSTNAME
#  config.vm.synced_folder "../synced", SITE, owner:"vagrant", group:"vagrant"

end