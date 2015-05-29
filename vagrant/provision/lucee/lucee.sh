#!/bin/sh

source /vagrant/provision/config

runfile=".runonce.lucee"
rundir="/opt/lucee"
luceePassword="vagrant"
luceeInstaller="http://railo.viviotech.net/downloader.cfm/id/133/file/lucee-4.5.1.000-pl0-linux-x64-installer.run"

if [ -f "${runfile}" ]; then
  echo "Lucee provisioning already completed - ${runfile} exists - exiting"
  exit 0
fi

if [ ! -d $rundir ]; then
  echo "Creating directory ${rundir} ..."
  mkdir -p "${rundir}"
fi

echo "Installing Lucee..."

if [ ! -f "${rundir}/lucee-installer.run" ]; then
  echo "Downloading Lucee..."
  wget -cnv $luceeInstaller -O "${rundir}/lucee-installer.run"
  chmod 744 "${rundir}/lucee-installer.run"
else
  echo "Lucee was already downloaded"
fi

${rundir}/lucee-installer.run --mode unattended --luceepass $luceePassword --debuglevel 1

service lucee_ctl stop

echo "Configuring Lucee for ${PRIVATE_NETWORK_IP} ..."

# rm -rf /var/www/WEB-INF # nn?

sed -e "s/localhost/$PRIVATE_NETWORK_IP/g" /vagrant/provision/lucee/server.xml > temp
mv temp "${rundir}/tomcat/conf/server.xml"
service lucee_ctl start
echo "Restarting Lucee..."
service httpd restart
touch "${runfile}"

echo "Install Lucee Completed"
