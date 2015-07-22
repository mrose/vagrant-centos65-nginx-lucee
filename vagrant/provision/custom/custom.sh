#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/provision/.custom.provisioned"
if [ -f "${runfile}" ]; then
  echo "custom provisioning already completed on `cat ${runfile}`"
  echo "exiting custom provisioning"
  exit 0
fi

echo "Applying custom provisioning..."

echo "Installing nano, git..."
yum -y install nano git

# install lucee admin passwords. a good security practice though :8080 is only exposed on localhost
echo "Setting Lucee server admin password..."
curl -F new_password=$LUCEE_SERVER_PASSWORD -F new_password_re=$LUCEE_SERVER_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/server.cfm >/dev/null 2>&1

echo "Setting Lucee web admin password..."
curl -F new_password=$LUCEE_WEB_PASSWORD -F new_password_re=$LUCEE_WEB_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/web.cfm >/dev/null 2>&1

echo "Executing custom script..."
if [ ! -d "/vagrant/tmp" ]; then
  mkdir /vagrant/tmp
fi
#cp /vagrant/provision/config /vagrant/tmp/config.ini
#sed -i '1i [all]' /vagrant/tmp/config.ini
#mv -f /vagrant/tmp/config.ini ${TOMCAT_HOME}/sites/$HOSTNAME/webroot/config.ini

sed s:lucee_server_password:"$LUCEE_SERVER_PASSWORD":g /vagrant/provision/custom/custom.cfm > /vagrant/tmp/custom.cfm
mv -f /vagrant/tmp/custom.cfm ${TOMCAT_HOME}/sites/$HOSTNAME/webroot/custom.cfm

curl http://localhost:8080/custom.cfm 2>/dev/null
#rm ${TOMCAT_HOME}/sites/$HOSTNAME/webroot/config.ini
rm ${TOMCAT_HOME}/sites/$HOSTNAME/webroot/custom.cfm
rmdir /vagrant/tmp

# install git and clone a repo into webroot now, if you like
#echo "Installing git..."
#yum -y install git

date > "${runfile}"
echo "Completed custom provisioning"