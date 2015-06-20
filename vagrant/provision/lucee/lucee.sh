#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.lucee"
if [ -f "${runfile}" ]; then
  echo "lucee provisioning already completed on `cat ${runfile}`"
  echo "exiting lucee provisioning"
  exit 0
fi

echo "Provisioning lucee..."

if [ ! -f "/vagrant/provision/downloads/lucee.war" ]; then
  echo "Downloading Lucee Web Archive..."
  wget -c -nv ${LUCEE_SRC} -O /vagrant/provision/downloads/lucee.war
else
  echo "Lucee Web Archive already downloaded"
fi

echo "Installing lucee to ${TOMCAT_HOME}/webapps/$HOSTNAME ..."
cp -f /vagrant/provision/downloads/lucee.war ${TOMCAT_HOME}/webapps/$HOSTNAME.war

service tomcat restart
service tomcat status
#  rm ${TOMCAT_HOME}/webapps/$HOSTNAME.war

date > "${runfile}"
echo "Completed lucee provisioning"