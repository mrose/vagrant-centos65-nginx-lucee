#!/bin/sh

runfile=".provision.java"
jdkyumsrc="java-1.8.0-openjdk java-1.8.0-openjdk-devel"
javahome="/usr/lib/jvm/java/"

#cookie="Cookie: oraclelicense=accept-securebackup-cookie"
#rpmsrc="http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm"
#rpmtarget="/opt/jdk-8-linux-x64.rpm"


if [ -f "${runfile}" ]; then
  echo "java provisioning already completed on `cat ${runfile}`"
  echo "exiting java provisioning"
  exit 0
fi

echo "Provisioning java ..."

yum -y install ${jdkyumsrc}

#wget --no-cookies --no-check-certificate --header "${cookie}" "${rpmsrc}" -O ${rpmtarget}
#rpm -Uvh ${rpmtarget}

export JAVA_HOME=${javahome}
java -version

date > "${runfile}"
echo "Completed java provisioning"