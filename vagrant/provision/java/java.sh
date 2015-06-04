#!/bin/sh

runfile=".provision.java"
jdk="java-1.8.0-openjdk java-1.8.0-openjdk-devel"
target="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45-28.b13.el6_6.x86_64"

#cookie="Cookie: oraclelicense=accept-securebackup-cookie"
#rpmsrc="http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm"
#rpmtarget="/opt/jdk-8-linux-x64.rpm"


if [ -f "${runfile}" ]; then
  echo "java provisioning already completed `cat ${runfile}`"
  echo "exiting java provisioning"
  exit 0
fi

echo "Provisioning java ..."

yum -y install ${jdk}

#wget --no-cookies --no-check-certificate --header "${cookie}" "${rpmsrc}" -O ${rpmtarget}
#rpm -Uvh ${rpmtarget}


export JAVA_HOME=/usr/lib/jvm/java/
java -version

date > "${runfile}"

echo "Completed java provisioning"