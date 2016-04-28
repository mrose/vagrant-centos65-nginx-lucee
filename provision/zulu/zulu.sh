#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned zulu

SRC="http://repos.azulsystems.com/rhel/zulu.repo"
JDK="zulu-8"

curl -o /etc/yum.repos.d/zulu.repo $SRC
rpm --import /vagrant/provision/zulu/zulu_signing.key
yum install $JDK

# below is so we don't have to reconfigure the tomcat install
#ln -s $JAVA_HOME /usr/java/default

#export JAVA_HOME=$JAVA_HOME
#java -version

provisioned zulu