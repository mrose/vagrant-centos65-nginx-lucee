#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned lucee "provisioning lucee to $TOMCAT_HOME/$LUCEE_ROOT/$LUCEE_WEBROOT/"

[ -d "$DOWNLOADS_DIR" ] || mkdir "$DOWNLOADS_DIR"
if [ ! -f "$DOWNLOADS_DIR/lucee.war" ]; then
  echo "Downloading Lucee Web Archive..."
  wget -c -nv ${LUCEE_SRC} -O ${DOWNLOADS_DIR}/lucee.war
fi
echo "Lucee Web Archive downloaded"

service tomcat stop

echo "Installing Lucee..."
# installing into ROOT
if [ "$TOMCAT_HOME/webapps/ROOT" = "$SITE_ROOT" ]; then
 mv $TOMCAT_HOME/webapps/ROOT $TOMCAT_HOME/webapps/originalROOT
fi
mkdir -p $SITE_WEBROOT
chmod -R 775 $SITE_ROOT

cp -f $DOWNLOADS_DIR/lucee.war $SITE_WEBROOT/lucee.war
chmod 755 $SITE_WEBROOT/lucee.war
cd $SITE_WEBROOT/
jar -xf lucee.war
chown -hR $TOMCAT_USER: $SITE_ROOT
chmod -R 775 $SITE_ROOT
cd $WORKING_DIR

# fix server.xml so that when tomcat starts WEB-INF is created
[ -d "$TEMP_DIR" ] || mkdir "$TEMP_DIR"
sed s:pathToDocBase:"$SITE_WEBROOT":g $PROVISION_DIR/lucee/server.xml > $TEMP_DIR/server.xml
mv -f $TEMP_DIR/server.xml $TOMCAT_HOME/conf/server.xml
rm -rf $TEMP_DIR

# customized context.xml to reduce startup times by not scanning for jar files
# see: http://www.gpickin.com/index.cfm/blog/how-to-get-your-tomcat-to-pounce-on-startup-not-crawl
cp -f $PROVISION_DIR/lucee/context.xml $TOMCAT_HOME/conf/context.xml
# owner/group s/b tomcat user
chown -hR $TOMCAT_USER: $TOMCAT_HOME/conf/context.xml

# commented out below since customized context above should fix it instead
# we start tomcat here to create/expand the WEB-INF directory
#service tomcat start
#service tomcat stop
#echo "Removing spurious tld references..."
# NOTE: subsequent tomcat restarts will fail unless we delete these 2 files
# see: http://markmail.org/thread/fcfg73mf3nsmd4x4#query:+page:1+mid:zskmphqmut5fqbve+state:results
#rm -rf $TOMCAT_HOME/$LUCEE_ROOT/$LUCEE_WEBROOT/WEB-INF/lucee-server/context/library/tld
# the .war file is no longer needed
#rm -f $TOMCAT_HOME/$LUCEE_ROOT/$LUCEE_WEBROOT/lucee.war

echo "Restarting tomcat- check status"
service tomcat start
service tomcat status

provisioned lucee