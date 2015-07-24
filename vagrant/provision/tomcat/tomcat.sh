#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/provision/.tomcat.provisioned"
if [ -f "${runfile}" ]; then
  echo "tomcat provisioning already completed on `cat ${runfile}`"
  exit 0
fi

echo "Provisioning tomcat..."

echo "Installing wget..."
yum -y install wget

tomcat_dir=$(basename ${TOMCAT_SRC} .tar.gz) # e.g. apache-tomcat-8.0.23

useradd -M -r ${TOMCAT_USER} --shell /bin/false

echo "Installing Apache Tomcat Native Library"
yum -y install apr-devel openssl-devel

echo "Downloading Tomcat..."
if [ ! -d "/vagrant/downloads" ]; then
  mkdir /vagrant/downloads
fi
if [ ! -f "/vagrant/downloads/${tomcat_dir}.tar.gz" ]; then
  wget -c -nv ${TOMCAT_SRC} -O /vagrant/downloads/${tomcat_dir}.tar.gz
else
  echo "...Tomcat already downloaded"
fi

echo "Extracting ${tomcat_dir}..."
tar -xzf /vagrant/downloads/${tomcat_dir}.tar.gz -C /opt

echo "Installing to ${TOMCAT_HOME}..."
mv /opt/${tomcat_dir} ${TOMCAT_HOME}
cp -f /vagrant/provision/tomcat/tomcat.init /etc/init.d/tomcat
chmod +x /etc/init.d/tomcat
# remove unnecessary windoze files
rm -f ${TOMCAT_HOME}/bin/*.bat

# remove examples & docs app
rm -rf ${TOMCAT_HOME}/webapps/docs
rm -rf ${TOMCAT_HOME}/webapps/examples

echo "Installing tomcat-users.xml..."
if [ ! -d "/vagrant/tmp" ]; then
  mkdir /vagrant/tmp
fi
sed -e s:tomcat_user:"$TOMCAT_USER": -e s:tomcat_manager_gui_password:"$TOMCAT_MANAGER_GUI_PASSWORD": /vagrant/provision/tomcat/tomcat-users.xml > /vagrant/tmp/tomcat-users.xml
mv -f /vagrant/tmp/tomcat-users.xml ${TOMCAT_HOME}/conf/tomcat-users.xml
rmdir /vagrant/tmp

chown -hR tomcat: ${TOMCAT_HOME}

service tomcat start
chkconfig tomcat on
service tomcat status

rm -f ${target}.tar.gz
date > "${runfile}"
echo "Completed tomcat provisioning"