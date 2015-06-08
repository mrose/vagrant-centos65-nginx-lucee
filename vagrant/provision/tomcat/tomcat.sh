#!/bin/sh

runfile=".provision.tomcat"
src="http://apache.spinellicreations.com/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz"
target="apache-tomcat-8.0.23"
tmp="/vagrant/.vagrant/tmp"
tomcathome="/opt/tomcat"

if [ -f "${runfile}" ]; then
  echo "tomcat provisioning already completed on `cat ${runfile}`"
  exit 0
fi

echo "Provisioning tomcat ..."

if [ ! -d $tmp ]; then
  mkdir -p "${tmp}"
fi

useradd -r tomcat8 --shell /bin/false


if [ ! -f "${target}.tar.gz" ]; then
  echo "Downloading Tomcat ..."
  wget -c -nv ${src} -O ${target}.tar.gz
else
  echo "Tomcat already downloaded"
fi

tar -zxf ${target}.tar.gz -C /opt
ln -s /opt/${target} ${tomcathome}
chown -hR tomcat8: ${tomcathome} /opt/${target}
cp -f /vagrant/provision/tomcat/tomcat.init /etc/init.d/tomcat8
chmod +x /etc/init.d/tomcat8

# other files get copied to /opt/tomcat/conf
cp -f /vagrant/provision/tomcat/tomcat-users.xml ${tomcathome}/conf/tomcat-users.xml

service tomcat8 start
chkconfig tomcat8 on
service tomcat8 status

date > "${runfile}"
echo "Completed tomcat provisioning"