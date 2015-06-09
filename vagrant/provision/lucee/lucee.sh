#!/bin/sh

source /vagrant/provision/config

runfile=".runonce.lucee"
luceePassword="vagrant"
src="http://bitbucket.org/lucee/lucee/downloads/lucee-4.5.1.000.war"
target="/opt/tomcat/webapps/lucee.war"

if [ -f "${runfile}" ]; then
  echo "lucee provisioning already completed on `cat ${runfile}`"
  echo "exiting lucee provisioning"
  exit 0
fi

echo "Provisioning lucee ..."

service tomcat stop

if [ ! -f "${target}" ]; then
  echo "Downloading Lucee Web Archive ..."
  wget -c -nv ${src} -O ${target}
else
  echo "Lucee Web Archive already downloaded"
fi


#${rundir}/lucee-installer.run --mode unattended --railopass $luceePassword --debuglevel 1

#echo "Configuring Lucee for ${PRIVATE_NETWORK_IP} ..."

service tomcat start

#rm -f ${target}
date > "${runfile}"
echo "Completed lucee provisioning"