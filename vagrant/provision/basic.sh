#!/bin/sh

runfile=".runonce.bootstrap"
tempdir="/vagrant/.vagrant/temp"

if [ -f "${runfile}" ]; then
  echo "bootstrap already completed - ${runfile} exists - exiting"
  exit 0
fi

if [ ! -d $tempdir ]; then
  # echo "Creating tempdir ${tempdir} ..."
  mkdir -p "${tempdir}"
fi

echo "Installing required software for $(hostname) ..."

date > /etc/vagrant_provisioned_at
yum -y update

echo "Installing nano, git, wget ..."
yum -y install nano git wget
touch "${runfile}" # on guest

echo "Completed Install of nano, git, wget"
