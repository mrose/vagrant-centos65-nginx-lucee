#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned kickstart "provisioning required basic software for guest $HOSTNAME at $PRIVATE_NETWORK_IP..."
echo "provisioning from root directory $PROVISION_DIR"
echo "working directory is $WORKING_DIR"
echo
echo "Updating OS software"
yum -y update

# set server timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
date

# disable ipv6 traffic
echo "...disabling IPv6"
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

provisioned kickstart