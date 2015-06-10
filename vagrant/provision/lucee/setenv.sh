# thanks Adam Bellas
# http://www.rendered-dreams.com/blog/2014/3/24/Deep-Dive-Multiple-sites-one-Railo-one-Tomcat

# Setup the JVM memory space and options
# ---------------------------------------------------------------------------------------------------
export CATALINA_OPTS="$CATALINA_OPTS -Xms512m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx512m"
#export CATALINA_OPTS="$CATALINA_OPTS -Xss384k"
#export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"
# A special parameter specifically for lucee
export CATALINA_OPTS="$CATALINA_OPTS -javaagent:${CATALINA_HOME}/lucee/lucee-inst.jar"