#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.custom"
if [ -f "${runfile}" ]; then
  echo "custom provisioning already completed on `cat ${runfile}`"
  echo "exiting custom provisioning"
  exit 0
fi

echo "Applying custom provisioning..."

echo "Installing nano..."
yum -y install nano

# install lucee admin passwords. a good security practice though :8080 is only exposed on localhost
echo "Setting Lucee server admin password..."
curl -F new_password=$LUCEE_SERVER_PASSWORD -F new_password_re=$LUCEE_SERVER_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/server.cfm >/dev/null 2>&1

echo "Setting Lucee web admin password..."
curl -F new_password=$LUCEE_WEB_PASSWORD -F new_password_re=$LUCEE_WEB_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/web.cfm >/dev/null 2>&1

echo "Executing custom kickstart script..."
sed s:lucee_server_password:"$LUCEE_SERVER_PASSWORD": /vagrant/provision/custom/kickstart.cfm > /vagrant/tmp/kickstart.cfm
mv -f /vagrant/tmp/kickstart.cfm ${TOMCAT_HOME}/sites/$HOSTNAME/webroot/kickstart.cfm
curl http://localhost:8080/kickstart.cfm  2>&1
rm ${TOMCAT_HOME}/sites/$HOSTNAME/webroot/kickstart.cfm

# install git and clone a repo into webroot now, if you like
#echo "Installing git..."
#yum -y install git

date > "${runfile}"
echo "Completed custom provisioning"