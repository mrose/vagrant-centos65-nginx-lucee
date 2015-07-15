#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.postfix"
if [ -f "${runfile}" ]; then
  echo "postfix provisioning already completed on `cat ${runfile}`"
  echo "exiting postfix provisioning"
  exit 0
fi

echo "Provisioning postfix..."

# replace all 'example.com' with hostname
sed s:example.com:"$HOSTNAME":g /vagrant/provision/postfix/main.cf > /vagrant/tmp/main.cf
if [ ! -f /etc/postfix/main.cf.original ]; then
  mv /etc/postfix/main.cf /etc/postfix/main.cf.original
fi
mv -f /vagrant/tmp/main.cf /etc/postfix/main.cf

service postfix restart
chkconfig postfix on

date > "${runfile}"
echo "Completed postfix provisioning"