#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned java

yum -y install $JDK_YUM_SRC
export JAVA_HOME=$JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH
java -version

provisioned java