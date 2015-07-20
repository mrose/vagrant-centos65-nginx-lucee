#!/bin/sh

source /vagrant/provision/config

runfile="/vagrant/.provision.iptables"
if [ -f "${runfile}" ]; then
  echo "iptables provisioning already completed on `cat ${runfile}`"
  echo "exiting iptables provisioning"
  exit 0
fi

echo "Provisioning iptables..."

# flush any existing
iptables -F

#echo "...block null packets"
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

#echo "...reject a syn-flood attack"
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

#echo "...reject xmas packets"
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

echo "...accept any localhost"
iptables -A INPUT -i lo -j ACCEPT

echo "...allow web server traffic to :80"
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

#echo "...allow web server traffic to :443"
#iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# allow :8080 to be visible in dev only
if [ ${ENVIRONMENT} = "dev" ]; then
  echo "...allow web server traffic to :8080"
  iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
fi

# allow smtp/s
# iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
# iptables -A INPUT -p udp -m udp --dport 25 -j ACCEPT 
# iptables -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT

# allow pop3/s
# iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT

# allow imap/s
# iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT

echo "...allow ssh from all IPs"
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
# or from only one IP:
# iptables -A INPUT -p tcp -s $HOST_IP_ADDRESS -m tcp --dport 22 -j ACCEPT

# ??? :1234/9418 git; :123 ntp; :3306 mariadb

echo "...allow any established outgoing connection to receive replies from other side of that connection"
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "...allow smtp out"
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p udp --dport 25 -j ACCEPT

echo "...block everything else"
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

echo "...saving configuration"
if [ ! -d "/vagrant/tmp" ]; then
  mkdir /vagrant/tmp
fi
iptables -S | tee /vagrant/tmp/iptables
sed -i '1i *filter' /vagrant/tmp/iptables
echo 'COMMIT' >> /vagrant/tmp/iptables
mv /vagrant/tmp/iptables /etc/sysconfig/iptables
rmdir /vagrant/tmp

service iptables restart

date > "${runfile}"
echo "Completed iptables provisioning"