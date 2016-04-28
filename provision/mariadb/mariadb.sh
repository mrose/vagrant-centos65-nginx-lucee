#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned mariadb

# NOTE: yum install creates a mysql user and group
# For compatibility, the service name and port are by default the same as MySQL: mysql and 3306.
# Binaries are also named the same: mysqld for the server and mysql for the client.

if [ -f /etc/yum.repos.d/mariadb.repo ]; then
  echo "mariadb rpm download and install already completed"
else
  echo "Installing mariadb..."
  cp -f $PROVISION_DIR/mariadb/mariadb.repo /etc/yum.repos.d/mariadb.repo
  rpm --import $PROVISION_DIR/mariadb/mariadb_signing.key
  yum -y install MariaDB-server MariaDB-client
fi

service mysql start
chkconfig mysql on
service mysql status

echo "Setting mariadb root password..."
# On yum-based distributions, the only MariaDB user set up is root, and there is no password
mysqladmin -u root password "$MARIADB_ROOT_PASSWORD"
# mysqladmin -u root -h "$HOSTNAME" password "$MARIADB_ROOT_PASSWORD"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "UPDATE mysql.user SET Password=PASSWORD('$MARIADB_ROOT_PASSWORD') WHERE User='root'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"

# create $PROVISION_USER (usually "vagrant") user so we can ssh to it
echo "Creating user $PROVISION_USER for database SSH..."
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE USER '$PROVISION_USER'@'localhost' IDENTIFIED BY '$PROVISION_USER'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON * . * TO '$PROVISION_USER'@'localhost'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"

# create lucee user and databases for session and client storage
echo "Creating lucee user..."
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE USER '$MARIADB_LUCEE_USER'@'localhost' IDENTIFIED BY '$MARIADB_LUCEE_PASSWORD'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON * . * TO '$MARIADB_LUCEE_USER'@'localhost'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS railo_client"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS railo_session"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS lucee_client"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS lucee_session"

provisioned mariadb