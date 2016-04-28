#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned custom

# install lucee admin passwords. a good security practice though :8080 is only exposed on localhost
echo "Setting Lucee server admin password..."
curl -F new_password=$LUCEE_SERVER_PASSWORD -F new_password_re=$LUCEE_SERVER_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/server.cfm >/dev/null 2>&1

echo "Setting Lucee web admin password..."
curl -F new_password=$LUCEE_WEB_PASSWORD -F new_password_re=$LUCEE_WEB_PASSWORD -F lang=en -F rememberMe=d -F submit=submit http://localhost:8080/lucee/admin/web.cfm >/dev/null 2>&1

echo "Executing custom script..."
[ -d "$TEMP_DIR" ] || mkdir -m 755 $TEMP_DIR

# you probably don't want to uncomment below unless you need config values for environment or such
#cp $PROVISION_DIR/config $TEMP_DIR/config.ini
#sed -i '1i [all]' $TEMP_DIR/config.ini
#mv -f $TEMP_DIR/config.ini $SITE_ROOT/config.ini

sed s:lucee_server_password:"$LUCEE_SERVER_PASSWORD":g $PROVISION_DIR/custom/custom.cfm > $TEMP_DIR/custom.cfm
mv -f $TEMP_DIR/custom.cfm $SITE_WEBROOT/customABC123.cfm

curl http://localhost:8080/customABC123.cfm 2>/dev/null
#rm $SITE_WEBROOT/customABC123.cfm
#rm $SITE_ROOT/config.ini
rm -rf $TEMP_DIR

provisioned custom