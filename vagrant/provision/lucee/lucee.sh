#!/bin/sh

# thanks Adam Bellas
# http://www.rendered-dreams.com/blog/2014/3/24/Deep-Dive-Multiple-sites-one-Railo-one-Tomcat

source /vagrant/provision/config

runfile=".provision.lucee"
if [ -f "${runfile}" ]; then
  echo "lucee provisioning already completed on `cat ${runfile}`"
  echo "exiting lucee provisioning"
  exit 0
fi

echo "Provisioning lucee ..."

#if [ ! -d "/vagrant/provision/downloads/lucee" ]; then
#  mkdir -p /vagrant/provision/downloads/lucee
#fi

if [ ! -f "/vagrant/provision/downloads/lucee.war" ]; then
  echo "Downloading Lucee Web Archive..."
  wget -c -nv ${LUCEE_SRC} -O /vagrant/provision/downloads/lucee.war
else
  echo "Lucee Web Archive already downloaded"
fi

echo "Extracting Lucee..."
if [ ! -d "/vagrant/provision/lucee/$HOSTNAME" ]; then
  mkdir  /vagrant/provision/lucee/$HOSTNAME
fi
#cp -f /vagrant/provision/downloads/lucee.war /vagrant/provision/lucee/$HOSTNAME
#cd /vagrant/provision/lucee/$HOSTNAME
#jar -xf lucee.war
#rm lucee.war
#cd /home/vagrant


echo "Installing Lucee..."
# remove a previous install if it exists
#if [ -d "${TOMCAT_HOME}/lucee" ]; then
#  rm -rf ${TOMCAT_HOME}/lucee
#fi
#mkdir -p ${TOMCAT_HOME}/lucee
# nb s/b mv
#cp -f /vagrant/provision/downloads/lucee/WEB-INF/lib/* ${TOMCAT_HOME}/lucee
#chown -hR ${TOMCAT_USER}: ${TOMCAT_HOME}/lucee

#cp -f /vagrant/provision/lucee/catalina.properties ${TOMCAT_HOME}/conf/catalina.properties
#cp -f /vagrant/provision/lucee/setenv.sh ${TOMCAT_HOME}/bin/setenv.sh
#cp -f /vagrant/provision/lucee/web.xml ${TOMCAT_HOME}/conf/web.xml

#sed s:example.com:"$HOSTNAME":g /vagrant/provision/lucee/server.xml > server.xml
#cp -f server.xml ${TOMCAT_HOME}/conf/server.xml
#rm server.xml

#if [ -d "/vagrant/.vagrant/tmp" ]; then
#  mkdir -p /vagrant/.vagrant/tmp
#fi

cp -f /vagrant/provision/downloads/lucee.war ${TOMCAT_HOME}/webapps/$HOSTNAME.war

service tomcat restart
service tomcat status
#date > "${runfile}"
echo "Completed lucee provisioning"