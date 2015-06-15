#!/bin/sh

source /vagrant/provision/config

runfile=".provision.tomcat"

if [ -f "${runfile}" ]; then
  echo "tomcat provisioning already completed on `cat ${runfile}`"
  exit 0
fi

echo "Provisioning tomcat..."

tomcat_dir=$(basename ${TOMCAT_SRC} .tar.gz) # e.g apache-tomcat-8.0.23

useradd -M -r ${TOMCAT_USER} --shell /bin/false

echo "Installing Apache Tomcat Native Library"
yum -y install apr-devel openssl-devel

if [ ! -f "/vagrant/provision/downloads/${tomcat_dir}.tar.gz" ]; then
  echo "Downloading Tomcat..."
  wget -c -nv ${TOMCAT_SRC} -O /vagrant/provision/downloads/${tomcat_dir}.tar.gz
else
  echo "Tomcat already downloaded"
fi

echo "Extracting ${tomcat_dir}..."
tar -xzf /vagrant/provision/downloads/${tomcat_dir}.tar.gz -C /opt

echo "Installing ${TOMCAT_HOME}..."
mv /opt/${tomcat_dir} ${TOMCAT_HOME}
chown -hR tomcat: ${TOMCAT_HOME}
cp -f /vagrant/provision/tomcat/tomcat.init /etc/init.d/tomcat
chmod +x /etc/init.d/tomcat
# remove unnecessary windoze files
rm -f ${TOMCAT_HOME}/bin/*.bat

echo "Copying tomcat-users.xml..."
cp -f /vagrant/provision/tomcat/tomcat-users.xml ${TOMCAT_HOME}/conf/tomcat-users.xml

if [ -d "${TOMCAT_HOME}/webapps/$HOSTNAME" ]; then
  mkdir ${TOMCAT_HOME}/webapps/$HOSTNAME
fi

service tomcat start
chkconfig tomcat on
service tomcat status

rm -f ${target}.tar.gz
date > "${runfile}"
echo "Completed tomcat provisioning"