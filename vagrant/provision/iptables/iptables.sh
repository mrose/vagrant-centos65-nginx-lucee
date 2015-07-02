#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.custom"
if [ -f "${runfile}" ]; then
  echo "custom provisioning already completed on `cat ${runfile}`"
  echo "exiting custom provisioning"
  exit 0
fi

echo "Provisioning iptables..."

#echo "Listing iptables rules..."

# allow in only
# 80 http
# 443 https
# 22 ssh
# 1234 git ??? 9418
# 123 ntp

# 3306 mysql/mariadb

iptables -L

date > "${runfile}"
echo "Completed iptables provisioning"