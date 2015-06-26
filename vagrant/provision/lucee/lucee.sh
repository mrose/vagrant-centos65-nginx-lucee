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


echo "Extracting Lucee..."
if [ ! -d "/vagrant/tmp" ]; then
  mkdir /vagrant/tmp
fi
cp /vagrant/downloads/lucee.war /vagrant/tmp/lucee.war
cd /vagrant/tmp
jar -xf lucee.war
rm -f lucee.war
cd /home/vagrant 

echo "Installing Lucee..."
mkdir ${TOMCAT_HOME}/lucee
mv /vagrant/tmp/WEB-INF/lib/* ${TOMCAT_HOME}/lucee
chown -hR ${TOMCAT_USER}: ${TOMCAT_HOME}/lucee

cp -f /vagrant/provision/lucee/catalina.properties ${TOMCAT_HOME}/conf/catalina.properties
cp -f /vagrant/provision/lucee/setenv.sh           ${TOMCAT_HOME}/bin/setenv.sh
cp -f /vagrant/provision/lucee/web.xml             ${TOMCAT_HOME}/conf/web.xml
sed s:example.com:"$HOSTNAME":g /vagrant/provision/lucee/server.xml > /vagrant/tmp/server.xml
mv -f /vagrant/tmp/server.xml ${TOMCAT_HOME}/conf/server.xml

mkdir -p ${TOMCAT_HOME}/sites/$HOSTNAME/webroot
mv /vagrant/tmp/* ${TOMCAT_HOME}/sites/$HOSTNAME/webroot
chown -hR ${TOMCAT_USER}: ${TOMCAT_HOME}/sites

# create lucee user and databases for session and client storage
sudo mysql -u root -p"$MARIADB_ROOT_PWD" -e "CREATE USER 'lucee'@'localhost' IDENTIFIED BY 'lucee'"
sudo mysql -u root -p"$MARIADB_ROOT_PWD" -e "GRANT ALL PRIVILEGES ON * . * TO 'lucee'@'localhost'"
sudo mysql -u root -p"$MARIADB_ROOT_PWD" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$MARIADB_ROOT_PWD" -e "CREATE DATABASE IF NOT EXISTS railo_client"
sudo mysql -u root -p"$MARIADB_ROOT_PWD" -e "CREATE DATABASE IF NOT EXISTS railo_session"

service tomcat restart
service tomcat status

date > "${runfile}"
echo "Completed lucee provisioning"