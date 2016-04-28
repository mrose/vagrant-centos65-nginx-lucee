#!/bin/sh

. /vagrant/config
WORKING_DIR=$(pwd)

function provisioned() {
  if [ -z "$1" ]; then
    echo usage: $0 provisionType
    exit
  fi

  f="$PROVISION_DIR/provisioned.$1"

  if [ -f "${f}" ]; then
    echo "`cat ${f}`"
    exit 0
  else
    if [ -z "$2" ]; then
      msg="provisioning..."
    else
      msg=$2
    fi
    echo "$1: $msg"
  fi

  echo "$1: provisioning completed $(date)" > "${f}"
}