#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.lucee"
if [ -f "${runfile}" ]; then
  echo "lucee provisioning already completed on `cat ${runfile}`"
  echo "exiting lucee provisioning"
  exit 0
fi

echo "Provisioning lucee..."

if [ ! -f "/vagrant/downloads/lucee.war" ]; then
  echo "Downloading Lucee Web Archive..."
  wget -c -nv ${LUCEE_SRC} -O /vagrant/downloads/lucee.war
else
  echo "Lucee Web Archive already downloaded"
fi

echo "Installing lucee to ${TOMCAT_HOME}/webapps/$HOSTNAME ..."
if [ -d "${TOMCAT_HOME}/webapps/$HOSTNAME" ]; then
  mkdir ${TOMCAT_HOME}/webapps/$HOSTNAME
fi
cp -f /vagrant/downloads/lucee.war ${TOMCAT_HOME}/webapps/$HOSTNAME.war

service tomcat restart
service tomcat status
# under rare circumstances tomcat fails to restart properly so we'll leave the war file in place
#  rm ${TOMCAT_HOME}/webapps/$HOSTNAME.war

date > "${runfile}"
echo "Completed lucee provisioning"