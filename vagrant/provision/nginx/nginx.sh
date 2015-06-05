#!/bin/sh

runfile=".provision.nginx"

if [ -f "${runfile}" ]; then
  echo "nginx provisioning already completed on `cat ${runfile}`"
  echo "exiting nginx provisioning"
  exit 0
fi

echo "Provisioning nginx ..."

cp -f /vagrant/provision/nginx/nginx.repo /etc/yum.repos.d/nginx.repo
rpm --import /vagrant/provision/nginx/nginx_signing.key
yum -y install nginx

echo "Writing nginx configuration files to: /etc/nginx/"
cp -f /vagrant/provision/nginx/nginx.conf /etc/nginx/nginx.conf
cp -f /vagrant/provision/nginx/default.conf /etc/nginx/conf.d/default.conf
cp -f /vagrant/provision/nginx/drop.conf /etc/nginx/conf.d/drop.conf
cp -f /vagrant/provision/nginx/lucee.conf /etc/nginx/conf.d/lucee.conf

service nginx start
chkconfig nginx on
service nginx status
date > "${runfile}"

#echo "nginx default SSL and vhost config directory: /etc/nginx/conf.d/"
echo "nginx default log file directory: /var/log/nginx/"
#echo "nginx default server access log file: /var/log/nginx/access.log"
#echo "nginx default server access log file: /var/log/nginx/error.log"
echo "nginx default document root directory: /usr/share/nginx/html"

echo "Completed nginx provisioning"