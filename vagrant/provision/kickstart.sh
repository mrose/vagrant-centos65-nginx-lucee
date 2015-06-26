#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.kickstart"
if [ -f "${runfile}" ]; then
  echo "kickstart provisioning for guest $HOSTNAME at ${PRIVATE_NETWORK_IP} already completed on `cat ${runfile}`"
  echo "exiting kickstart provisioning"
  exit 0
fi

echo "Provisioning required basic software for guest $HOSTNAME at ${PRIVATE_NETWORK_IP}..."

# set server timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
date

if [ ! -d "/vagrant/downloads" ]; then
  mkdir /vagrant/downloads
fi

# update to 6.5+ presumably more secure & better
#yum -y update

echo "Installing nano, wget..."
yum -y install nano wget

date > "${runfile}"
echo "Completed kickstart provisioning"