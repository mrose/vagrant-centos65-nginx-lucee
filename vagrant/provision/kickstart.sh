#!/bin/sh

source /vagrant/provision/config

runfile=".provision.kickstart"
if [ -f "${runfile}" ]; then
  echo "kickstart provisioning for guest $HOSTNAME at ${PRIVATE_NETWORK_IP} already completed on `cat ${runfile}`"
  echo "exiting kickstart provisioning"
  exit 0
fi

echo "Provisioning required basic software for guest $HOSTNAME at ${PRIVATE_NETWORK_IP}..."

if [ ! -d "/vagrant/provision/downloads" ]; then
  mkdir /vagrant/provision/downloads
fi

# set server timezone
echo $1 | ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime

# update to 6.5+ presumably more secure & better
#yum -y update

echo "Installing nano, git, wget ..."
yum -y install nano git wget
date > "${runfile}"

echo "Completed kickstart provisioning"