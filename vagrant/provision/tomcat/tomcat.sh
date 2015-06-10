#!/bin/sh

runfile=".provision.tomcat"
tomcatsrc="http://apache.spinellicreations.com/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz"
tomcathome="/opt/tomcat"

#target=basename ${tomcatsrc} .tar.gz
target="apache-tomcat-8.0.23"

if [ -f "${runfile}" ]; then
  echo "tomcat provisioning already completed on `cat ${runfile}`"
  exit 0
fi

echo "Provisioning tomcat ..."

useradd -M -r tomcat --shell /bin/false

if [ ! -f "${target}.tar.gz" ]; then
  echo "Downloading Tomcat ..."
  wget -c -nv ${tomcatsrc} -O ${target}.tar.gz
else
  echo "Tomcat already downloaded"
fi

tar -xzf ${target}.tar.gz -C /opt
ln -s /opt/${target} ${tomcathome}
chown -hR tomcat: ${tomcathome} /opt/${target}
cp -f /vagrant/provision/tomcat/tomcat.init /etc/init.d/tomcat
chmod +x /etc/init.d/tomcat
cp -f /vagrant/provision/tomcat/tomcat-users.xml ${tomcathome}/conf/tomcat-users.xml

# remove unnecessary files
rm -f ${tomcathome}/bin/*.bat
# ?remove /docs /examples

service tomcat start
chkconfig tomcat on
service tomcat status

rm -f ${target}.tar.gz
date > "${runfile}"
echo "Completed tomcat provisioning"