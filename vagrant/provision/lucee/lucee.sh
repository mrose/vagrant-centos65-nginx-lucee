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

if [ ! -d "/vagrant/provision/downloads/lucee" ]; then
  mkdir /vagrant/provision/downloads/lucee
fi

if [ ! -f "/vagrant/provision/downloads/lucee/lucee.war" ]; then
  echo "Downloading Lucee Web Archive ..."
  wget -c -nv ${LUCEE_SRC} -O /vagrant/provision/downloads/lucee/lucee.war
else
  echo "Lucee Web Archive already downloaded"
fi

echo "Extracting Lucee..."
cd /vagrant/provision/downloads/lucee
jar -xf lucee.war
cd /home/vagrant

if [ -d "${TOMCAT_HOME}/lucee" ]; then
  rm -rf ${TOMCAT_HOME}/lucee
fi
mkdir ${TOMCAT_HOME}/lucee

mv /vagrant/provision/downloads/lucee/WEB-INF/lib/* ${TOMCAT_HOME}/lucee
chown -hR ${TOMCAT_USER}: ${TOMCAT_HOME}/lucee

# mv the rest somewhere?
cp -f /vagrant/provision/lucee/catalina.properties ${TOMCAT_HOME}/conf/catalina.properties
cp -f /vagrant/provision/lucee/setenv.sh ${TOMCAT_HOME}/bin/setenv.sh
#cp -f /vagrant/provision/lucee/web.xml ${TOMCAT_HOME}/conf/web.xml

#sed s:example.com:"$HOSTNAME":g /vagrant/provision/lucee/server.xml > server.xml
#cp -f server.xml ${TOMCAT_HOME}/conf/server.xml
#rm server.xml

service tomcat restart
service tomcat status
#date > "${runfile}"
echo "Completed lucee provisioning"