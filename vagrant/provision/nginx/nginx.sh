#!/bin/sh

runfile=".runonce.nginx"

if [ -f "${runfile}" ]; then
  echo "Nginx provisioning already completed - ${runfile} exists - exiting"
  exit 0
fi

echo "Installing nginx ..."

wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum -y install nginx

service nginx start
chkconfig nginx on
service nginx status
touch "${runfile}"

echo "Nginx Install Completed"
