#!/bin/sh

# yum install creates a mysql user and group
# For compatibility, the service name and port are by default the same as MySQL: mysql and 3306.
# Binaries are also named the same: mysqld for the server and mysql for the client.

source /vagrant/provision/config

runfile="/vagrant/.provision.mariadb"
if [ -f "${runfile}" ]; then
  echo "mariadb provisioning already completed on `cat ${runfile}`"
  echo "exiting mariadb provisioning"
  exit 0
fi

echo "Provisioning mariadb..."
if [ -f /etc/yum.repos.d/mariadb.repo ]; then
  echo "mariadb rpm download and install already completed"
else
  echo "Installing mariadb..."
  cp -f /vagrant/provision/mariadb/mariadb.repo /etc/yum.repos.d/mariadb.repo
  rpm --import /vagrant/provision/mariadb/mariadb_signing.key
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
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE USER 'vagrant'@'localhost' IDENTIFIED BY 'vagrant'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON * . * TO 'vagrant'@'localhost'"
mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"

date > "${runfile}"
echo "Completed mariadb provisioning"
