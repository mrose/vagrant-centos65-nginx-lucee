#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.custom"
if [ -f "${runfile}" ]; then
  echo "custom provisioning already completed on `cat ${runfile}`"
  echo "exiting custom provisioning"
  exit 0
fi

echo "Provisioning custom..."

echo "Installing git..."
yum -y install git

date > "${runfile}"
echo "Completed custom provisioning"