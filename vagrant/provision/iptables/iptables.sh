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

# block null packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# reject a syn-flood attack
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# reject xmas packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# accept any localhost
iptables -A INPUT -i lo -j ACCEPT

# allow web server traffic
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# smtp/s
iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT

# pop3/s
# iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT

# imap/s
# iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT

# ssh from all IPs
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
# or from only one IP:
# iptables -A INPUT -p tcp -s $HOST_IP_ADDRESS -m tcp --dport 22 -j ACCEPT

# ??? :1234/9418 git; :123 ntp; :3306 mariadb

# allow any established outgoing connection to receive replies from other side of that connection
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# block everything else
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

iptables -save | tee /etc/sysconfig/iptables
service iptables restart
echo "Listing iptables rules..."
iptables -L -n

date > "${runfile}"
echo "Completed iptables provisioning"