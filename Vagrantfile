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
    vb.customize ["modifyvm", :id, "--memory", MEMORY]
  end

  config.vm.provision :shell, :path => "provision/kickstart/kickstart.sh"
  config.vm.provision :shell, :path => "provision/java/java.sh"
  config.vm.provision :shell, :path => "provision/tomcat/tomcat.sh"
  config.vm.provision :shell, :path => "provision/lucee/lucee.sh"
  config.vm.provision :shell, :path => "provision/nginx/nginx.sh"
  config.vm.provision :shell, :path => "provision/postfix/postfix.sh"
  config.vm.provision :shell, :path => "provision/mariadb/mariadb.sh"
  config.vm.provision :shell, :path => "provision/custom/custom.sh"
  config.vm.provision :shell, :path => "provision/iptables/iptables.sh"

# use ssh tunneling, vpn, or similar:
# http://dnando.github.io/blog/2014/11/04/ssh-tunneling-coldfusion-lockdown-technique/
# http://stackoverflow.com/questions/4216822/work-on-a-remote-project-with-eclipse-via-ssh
# https://github.com/apenwarr/sshuttle/blob/master/README.md

#  SITE = TOMCAT_HOME + '/sites/' + HOSTNAME
#  config.vm.synced_folder "../synced", SITE, owner:"vagrant", group:"vagrant"

end