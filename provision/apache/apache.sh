#!/bin/sh

. /vagrant/provision/provisionable.sh
provisioned apache

yum -y install httpd

service httpd start
chkconfig httpd on
service httpd status

provisioned apache