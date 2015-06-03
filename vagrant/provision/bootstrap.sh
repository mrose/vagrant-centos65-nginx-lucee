#!/bin/sh

runfile=".runonce.bootstrap"
tempdir="/vagrant/.vagrant/temp"
jdk="java-1.8.0-openjdk-devel.x86_64"

if [ -f "${runfile}" ]; then
  d=`cat ${runfile}`
  echo "bootstrap provisioning already completed ${d}"
  echo "exiting"
  exit 0
fi

if [ ! -d $tempdir ]; then
  # echo "Creating tempdir ${tempdir} ..."
  mkdir -p "${tempdir}"
fi

echo "Provisioning required bootstrap software for guest $(hostname) ..."

#yum -y update

echo "Installing nano, git, wget ..."
yum -y install nano git wget
echo ""
echo "Installing java ..."
yum -y install ${jdk}
date > "${runfile}"

echo "Completed bootstrap provisioning"