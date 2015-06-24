#!/bin/sh

# note: JAVA_OPTS are set in the tomcat.init script

CATALINA_OPTS="$CATALINA_OPTS -javaagent:/opt/tomcat/lucee/lucee-inst.jar"
export CATALINA_OPTS;