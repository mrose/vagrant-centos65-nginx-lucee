#!/bin/sh

runfile=".runonce.apache"
if [ -f "${runfile}" ]; then
  echo "Apache provisioning already completed on `cat ${runfile}`"
  exit 0
fi

echo "Installing Apache..."
yum -y install httpd

service httpd start
chkconfig httpd on
service httpd status

date > "${runfile}"
echo "Apache provisioning completed"