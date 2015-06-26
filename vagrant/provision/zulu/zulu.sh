#!/bin/sh

runfile="/vagrant/.provision.zulu"
src="http://repos.azulsystems.com/rhel/zulu.repo"
jdk="zulu-8"

if [ -f "${runfile}" ]; then
  echo "zulu provisioning already completed `cat ${runfile}`"
  echo "exiting zulu provisioning"
  exit 0
fi

echo "Provisioning zulu ..."

curl -o /etc/yum.repos.d/zulu.repo ${src}
rpm --import /vagrant/provision/zulu/zulu_signing.key
yum install ${jdk}

# below is so we don't have to reconfigure the tomcat install
#ln -s ${javahome} /usr/java/default

#export JAVA_HOME=${javahome}
#java -version

date > "${runfile}"
echo "Completed java provisioning"