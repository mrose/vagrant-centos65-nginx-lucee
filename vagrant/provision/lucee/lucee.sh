#!/bin/sh

# thanks Adam Bellas
# http://www.rendered-dreams.com/blog/2014/3/24/Deep-Dive-Multiple-sites-one-Railo-one-Tomcat

source /vagrant/provision/config

runfile=".provision.lucee"
# luceePassword="vagrant"
luceesrc="http://bitbucket.org/lucee/lucee/downloads/lucee-4.5.1.000.war"
luceetmp="/home/vagrant/lucee"


tomcathome="/opt/tomcat"


if [ -f "${runfile}" ]; then
  echo "lucee provisioning already completed on `cat ${runfile}`"
  echo "exiting lucee provisioning"
  exit 0
fi

echo "Provisioning lucee ..."
service tomcat stop

if [ ! -d ${luceetmp} ]; then
  mkdir -p "${luceetmp}"
fi

if [ ! -f "${luceetmp}/lucee.war" ]; then
  echo "Downloading Lucee Web Archive ..."
  wget -c -nv ${luceesrc} -O ${luceetmp}/lucee.war
else
  echo "Lucee Web Archive already downloaded"
fi

cd ${luceetmp}
jar -xf lucee.war
cd /home/vagrant

chown -hR tomcat: ${luceetmp}
mkdir ${tomcathome}/lucee
mv ${luceetmp}/WEB-INF/lib/* ${tomcathome}/lucee
# rm -f ${luceetmp}/lucee.war
# mv the rest somewhere?
cp -f /vagrant/provision/lucee/catalina.properties ${tomcathome}/conf/catalina.properties
cp -f /vagrant/provision/lucee/setenv.sh ${tomcathome}/bin/setenv.sh

#sed s:example.com:"$HOSTNAME":g /vagrant/provision/tomcat/server.xml > server.xml
#mv -f server.xml ${tomcathome}/conf/server.xml

service tomcat start
service tomcat status
date > "${runfile}"
echo "Completed lucee provisioning"