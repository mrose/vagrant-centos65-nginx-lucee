#!/bin/sh

source /vagrant/provision/config

runfile=".provision.java"
if [ -f "${runfile}" ]; then
  echo "java provisioning already completed on `cat ${runfile}`"
  echo "exiting java provisioning"
  exit 0
fi

echo "Provisioning java..."

yum -y install ${JDK_YUM_SRC}
export JAVA_HOME=${JAVA_HOME}
java -version

date > "${runfile}"
echo "Completed java provisioning"