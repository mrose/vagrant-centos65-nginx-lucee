#!/bin/sh

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

# For compatibility, the service name and port are by default the same as MySQL: mysql and 3306.

# Binaries are also named the same: mysqld for the server and mysql for the client.

service mysql start
chkconfig mysql on
service mysql status

echo "Setting mariadb root password..."
# On yum-based distributions, the only MariaDB user set up is root, and there is no password.
mysqladmin -u root password "$MARIADB_ROOT_PWD"
mysql -u root -p"$MARIADB_ROOT_PWD" -e "UPDATE mysql.user SET Password=PASSWORD('$MARIADB_ROOT_PWD') WHERE User='root'"
mysql -u root -p"$MARIADB_ROOT_PWD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$MARIADB_ROOT_PWD" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$MARIADB_ROOT_PWD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$MARIADB_ROOT_PWD" -e "FLUSH PRIVILEGES"

date > "${runfile}"
echo "Completed mariadb provisioning"
