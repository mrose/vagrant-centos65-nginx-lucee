#!/bin/sh

runfile=".provision.nginx"

if [ -f "${runfile}" ]; then
  echo "nginx provisioning already completed `cat ${runfile}`"
  echo "exiting nginx provisioning"
  exit 0
fi

echo "Provisioning nginx ..."

cp -f /vagrant/provision/nginx/nginx.repo /etc/yum.repos.d/nginx.repo
rpm --import /vagrant/provision/nginx/nginx_signing.key
yum -y install nginx

service nginx start
chkconfig nginx on
service nginx status
date > "${runfile}"

#echo "nginx default configuration directory: /etc/nginx/"
echo "nginx default configuration file: /etc/nginx/nginx.conf"

#echo "turn sendfile off in the config per https://kisdigital.wordpress.com/tag/nginx/"

#echo "Configure the number of worker processes in nginx.conf (default is 1) should match CPU(s):"
#echo sudo lscpu | grep '^CPU(s)'
#echo "Also turn on gzip support (default is commented out): gzip  on;"
#echo "nginx default SSL and vhost config directory: /etc/nginx/conf.d/"
echo "nginx default log file directory: /var/log/nginx/"
#echo "nginx default server access log file: /var/log/nginx/access.log"
#echo "nginx default server access log file: /var/log/nginx/error.log"
echo "nginx default document root directory: /usr/share/nginx/html"

echo "Completed nginx provisioning"