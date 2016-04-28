#!/bin/sh -e

source provision/config

sudo cp /etc/hosts /etc/hosts.original
sudo sh -c "echo '${PRIVATE_NETWORK_IP}\t${HOSTNAME}' >> /etc/hosts"

# now flush mac DNS
sudo killall -HUP mDNSResponder