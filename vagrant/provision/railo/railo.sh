#!/bin/sh

source /vagrant/provision/config

runfile=".runonce.railo"
rundir="/opt/railo"
railoPassword="vagrant"
railoInstaller="http://www.getrailo.org/down.cfm?item=/railo/remote/download42/4.2.1.000/tomcat/linux/railo-4.2.1.000-pl2-linux-x64-installer.run&thankyou=false"

if [ -f "${runfile}" ]; then
  echo "Railo provisioning already completed - ${runfile} exists - exiting"
  exit 0
fi

if [ ! -d $rundir ]; then
  echo "Creating directory ${rundir} ..."
  mkdir -p "${rundir}"
fi

echo "Installing Railo ..."

if [ ! -f "${rundir}/railo-installer.run" ]; then
  echo "Downloading Railo ..."
  wget -cq $railoInstaller -O "${rundir}/railo-installer.run"
  chmod 744 "${rundir}/railo-installer.run"
else
  echo "Railo already downloaded"
fi

# note that under these install options railo runs as root.
# in a production deployment you might not want that
${rundir}/railo-installer.run --mode unattended --railopass $railoPassword --debuglevel 1

service railo_ctl stop

echo "Configuring Railo for ${PRIVATE_NETWORK_IP} ..."

# rm -rf /var/www/WEB-INF # nn?

sed -e "s/localhost/$PRIVATE_NETWORK_IP/g" /vagrant/provision/railo/server.xml > temp
mv temp "${rundir}/tomcat/conf/server.xml"
service railo_ctl start
echo "Restarting Apache ..."
service httpd restart
touch "${runfile}"

echo "Install Railo Completed"
