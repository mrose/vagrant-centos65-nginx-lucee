#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned tomcat

[ -d "$DOWNLOADS_DIR" ] || mkdir "$DOWNLOADS_DIR"

tomcat_dir=$(basename ${TOMCAT_SRC} .tar.gz) # e.g. apache-tomcat-8.0.23
if [ ! -f "$DOWNLOADS_DIR/$tomcat_dir.tar.gz" ]; then
  echo "Installing wget..."
  yum -y install wget
  echo "Downloading Tomcat..."
  wget -c -nv $TOMCAT_SRC -O $DOWNLOADS_DIR/$tomcat_dir.tar.gz
fi
echo "Tomcat downloaded"

echo "Extracting $tomcat_dir..."
tar -xzf $DOWNLOADS_DIR/$tomcat_dir.tar.gz -C /opt

echo "Installing to $TOMCAT_HOME..."
mv /opt/$tomcat_dir $TOMCAT_HOME
if [ -f $PROVISION_DIR/tomcat/tomcat.init ]; then
  echo "Installing tomcat.init script to /etc/init.d"
  cp -f $PROVISION_DIR/tomcat/tomcat.init /etc/init.d/tomcat
  chmod +x /etc/init.d/tomcat
else
  echo "WARNING: $PROVISION_DIR/tomcat/tomcat.init was not found"
fi
if [ -f $PROVISION_DIR/tomcat/setenv.sh ]; then
  echo "Installing $TOMCAT_HOME/bin/setenv.sh"
  cp -f $PROVISION_DIR/tomcat/setenv.sh $TOMCAT_HOME/bin/setenv.sh
  chmod 755 $TOMCAT_HOME/bin/setenv.sh
else
  echo "WARNING: $PROVISION_DIR/tomcat/setenv.sh was not found"
fi

# remove unnecessary windoze files
rm -f $TOMCAT_HOME/bin/*.bat

echo "Installing tomcat-users.xml..."
[ -d "$TEMP_DIR" ] || mkdir -m 755 $TEMP_DIR
sed -e s:tomcat_user:"$TOMCAT_USER": -e s:tomcat_manager_gui_password:"$TOMCAT_MANAGER_GUI_PASSWORD": $PROVISION_DIR/tomcat/tomcat-users.xml > $TEMP_DIR/tomcat-users.xml
mv -f $TEMP_DIR/tomcat-users.xml $TOMCAT_HOME/conf/tomcat-users.xml
rm -rf $TEMP_DIR

useradd -M -r $TOMCAT_USER --shell /bin/false
chown -hR $TOMCAT_USER: $TOMCAT_HOME

# vagrant user, added to tomcat group, can edit using ssh
usermod -g tomcat $PROVISION_USER

service tomcat start
chkconfig tomcat on
service tomcat status

provisioned tomcat