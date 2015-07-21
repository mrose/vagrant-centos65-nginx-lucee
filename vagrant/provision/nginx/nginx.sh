#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/provision/.nginx.provisioned"
if [ -f "${runfile}" ]; then
  echo "nginx provisioning already completed on `cat ${runfile}`"
  echo "exiting nginx provisioning"
  exit 0
fi

echo "Provisioning nginx..."

if [ -f /etc/yum.repos.d/nginx.repo ]; then
  echo "nginx rpm download and install already completed"
else
  echo "Installing nginx..."
  cp -f /vagrant/provision/nginx/nginx.repo /etc/yum.repos.d/nginx.repo
  rpm --import /vagrant/provision/nginx/nginx_signing.key
  yum -y install nginx
fi

echo "Writing nginx configuration files to: /etc/nginx/ ..."
cp -f /vagrant/provision/nginx/nginx.conf /etc/nginx/nginx.conf

sed s:example.com:"$HOSTNAME":g /vagrant/provision/nginx/default.conf > temp
mv -f temp /etc/nginx/conf.d/default.conf

cp -f /vagrant/provision/nginx/drop.conf /etc/nginx/conf.d/drop.conf

sed s:example.com:"$HOSTNAME":g /vagrant/provision/nginx/lucee.conf > temp
mv -f temp /etc/nginx/conf.d/$HOSTNAME.conf

service nginx start
chkconfig nginx on
service nginx status

echo "nginx default log file directory: /var/log/nginx/"
date > "${runfile}"
echo "Completed nginx provisioning"