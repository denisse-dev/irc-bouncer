#!/bin/bash

function install_packages() {
    sudo yum update -y
    sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
    sudo yum install znc emacs firewalld tmux -y
}

function configure_timezone() {
    echo 'ZONE="America/Mexico_City"' >> /etc/sysconfig/clock
    sudo ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
}

function start_daemons() {
    sudo systemctl enable znc
    sudo systemctl start znc
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
}

function configure_firewall() {
    sudo firewall-cmd --permanent --add-service=ssh
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
}

install_packages
configure_timezone
start_daemons
configure_firewall
