#!/bin/sh

source /vagrant/provision/config

runfile=".provision.bootstrap"
tempdir="/vagrant/.vagrant/temp"

if [ -f "${runfile}" ]; then
  echo "bootstrap provisioning for guest $HOSTNAME at ${PRIVATE_NETWORK_IP} already completed on `cat ${runfile}`"
  echo "exiting bootstrap provisioning"
  exit 0
fi

if [ ! -d $tempdir ]; then
  # echo "Creating tempdir ${tempdir} ..."
  mkdir -p "${tempdir}"
fi

echo "Provisioning required bootstrap software for guest $HOSTNAME at ${PRIVATE_NETWORK_IP} ..."

# update to 6.5+ presumably more secure & better
#yum -y update

echo "Installing nano, git, wget ..."
yum -y install nano git wget
date > "${runfile}"

echo "Completed bootstrap provisioning"