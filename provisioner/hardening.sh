#!/bin/bash

SSHD_CONFIG=(
    '#Port 22/Port 45632'
    '#PermitRootLogin yes/PermitRootLogin no'
    '#ClientAliveInterval 0/ClientAliveInterval 300'
    '#ClientAliveCountMax 3/ClientAliveCountMax 2'
    '#MaxAuthTries 6/MaxAuthTries 3'
    'X11Forwarding yes/X11Forwarding no'
)
LOCATION='/etc/ssh/sshd_config'

function configure_sshd() {
    for i in "${SSHD_CONFIG[@]}";
    do
        sed -i 's/'"$i"'/g' "$LOCATION"
    done
    systemctl reload sshd
    systemctl restart sshd
    systemctl enable sshd
}

function configure_firewall() {
    firewall-cmd --zone=public --permanent --add-port=45632/tcp
    firewall-cmd --zone=public --permanent --add-port=6697/tcp
    firewall-cmd --reload
    systemctl start firewalld
    systemctl enable firewalld
}

configure_sshd
configure_firewall
