#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned postfix

[ -d "$TEMP_DIR" ] || mkdir -m 755 $TEMP_DIR

# replace all 'example.com' with hostname
#domain=`echo $HOSTNAME | egrep -o '(\.[A-Za-z0-9-]+){2}$'`
sed s:example.com:"$HOSTNAME":g $PROVISION_DIR/postfix/main.cf > $TEMP_DIR/main.cf
[ ! -f /etc/postfix/main.cf.original ] ||  mv /etc/postfix/main.cf /etc/postfix/main.cf.original
mv -f $TEMP_DIR/main.cf /etc/postfix/main.cf
rm -rf $TEMP_DIR

service postfix restart
chkconfig postfix on

provisioned postfix