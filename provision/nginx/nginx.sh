#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned nginx

if [ -f /etc/yum.repos.d/nginx.repo ]; then
  echo "nginx rpm download and install already completed"
else
  echo "Installing nginx..."
  cp -f $PROVISION_DIR/nginx/nginx.repo /etc/yum.repos.d/nginx.repo
  rpm --import $PROVISION_DIR/nginx/nginx_signing.key
  yum -y install nginx
fi

echo "Writing nginx configuration files to: /etc/nginx/ ..."
cp -f $PROVISION_DIR/nginx/nginx.conf /etc/nginx/nginx.conf

[ -d "$TEMP_DIR" ] || mkdir "$TEMP_DIR"
sed s:webroot:"$SITE_WEBROOT":g $PROVISION_DIR/nginx/default.conf > $TEMP_DIR/default.conf
mv -f $TEMP_DIR/default.conf /etc/nginx/conf.d/default.conf

cp -f $PROVISION_DIR/nginx/drop.conf /etc/nginx/conf.d/drop.conf

sed s:example.com:"$HOSTNAME":g $PROVISION_DIR/nginx/lucee.conf > $TEMP_DIR/lucee.conf
mv -f $TEMP_DIR/lucee.conf /etc/nginx/conf.d/lucee.conf
rm -rf $TEMP_DIR

service nginx start
chkconfig nginx on
service nginx status
echo "nginx log file directory: /opt/tomcat/logs/"
echo
provisioned nginx