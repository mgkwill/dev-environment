#!/usr/bin/env bash

set +e

####
####
## Install Updates and git pip and vim
echo "deltarpm=0" >> /etc/dnf/dnf.conf
dnf update -y
dnf install -y git python-pip vim
#####
#####
## Add openstack user
/opt/stack/devstack/tools/create-stack-user.sh
#####
## Goto devstack and edit local.conf
cd /opt/stack/devstack/
git pull

cat <<EOF | sudo tee local.conf
[[local|localrc]]
ADMIN_PASSWORD=secrete
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
SERVICE_TOKEN=a682f596-76f3-11e3-b3b2-e716f9080d50
GIT_BASE=https://git.openstack.org
disable_service n-net
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service q-meta
enable_service neutron
EOF
cp -R /opt/stack/devstack /opt/stack/devstack_run
cp /home/vagrant/.bash* /opt/stack/.
chown -R stack:stack /opt/stack/*
#####
#####
## Stack
#./stack.sh

