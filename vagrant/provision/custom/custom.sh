#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.custom"
if [ -f "${runfile}" ]; then
  echo "custom provisioning already completed on `cat ${runfile}`"
  echo "exiting custom provisioning"
  exit 0
fi

echo "Provisioning custom..."

# install git and clone a repo, if you like
#echo "Installing git..."
#yum -y install git

# install lucee admin passwords.
# not really necessary since :8080 is only exposed on localhost
# but from a security perspective a good practice

echo "Setting Lucee server admin password..."
curl -F new_password=$LUCEE_SERVER_PASSWORD -F new_password_re=$LUCEE_SERVER_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/server.cfm >/dev/null

echo "Setting Lucee web admin password..."
curl -F new_password=$LUCEE_WEB_PASSWORD -F new_password_re=$LUCEE_WEB_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/web.cfm >/dev/null

date > "${runfile}"
echo "Completed custom provisioning"