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

# update to 6.5+ presumably more secure & better
#yum -y update

date > "${runfile}"
echo "Completed kickstart provisioning"