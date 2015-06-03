#!/bin/sh

runfile=".provision.bootstrap"
tempdir="/vagrant/.vagrant/temp"
jdk="java-1.8.0-openjdk java-1.8.0-openjdk-devel"
javahome="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45-28.b13.el6_6.x86_64"

if [ -f "${runfile}" ]; then
  d=`cat ${runfile}`
  echo "bootstrap provisioning already completed ${d}"
  echo "exiting"
  exit 0
fi

if [ ! -d $tempdir ]; then
  # echo "Creating tempdir ${tempdir} ..."
  mkdir -p "${tempdir}"
fi

echo "Provisioning required bootstrap software for guest $(hostname) ..."

# update to 6.5+ presumably more secure & better
#yum -y update

echo "Installing nano, git, wget ..."
yum -y install nano git wget
echo ""
echo "Installing java ..."
yum -y install ${jdk}
export JAVA_HOME=${javahome}
java -version
# cd /opt/
# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz"
# tar xzf jdk-7u79-linux-x64.tar.gz

date > "${runfile}"

echo "Completed bootstrap provisioning"