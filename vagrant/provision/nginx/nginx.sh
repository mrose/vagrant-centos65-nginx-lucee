#!/bin/sh

runfile=".runonce.nginx"
rpmfile="http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm"

if [ -f "${runfile}" ]; then
  echo "nginx provisioning already completed - ${runfile} exists - exiting"
  exit 0
fi

echo "Installing nginx ..."

if [ ! -f "nginx.rpm" ]; then
  echo "Downloading nginx RPM..."
  wget -c "${rpmfile}" -O nginx.rpm
else
  echo "nginx was already downloaded"
fi

rpm -ivh nginx.rpm
yum -y install nginx

service nginx start
chkconfig nginx on
service nginx status
touch "${runfile}"

#echo "nginx default configuration directory: /etc/nginx/"
echo "nginx default configuration file: /etc/nginx/nginx.conf"
#echo "Configure the number of worker processes in nginx.conf (default is 1) should match CPU(s):"
#echo sudo lscpu | grep '^CPU(s)'
#echo "Also turn on gzip support (default is commented out): gzip  on;"
#echo "nginx default SSL and vhost config directory: /etc/nginx/conf.d/"
echo "nginx default log file directory: /var/log/nginx/"
#echo "nginx default server access log file: /var/log/nginx/access.log"
#echo "nginx default server access log file: /var/log/nginx/error.log"
echo "nginx default document root directory: /usr/share/nginx/html"

echo "nginx Install Completed"