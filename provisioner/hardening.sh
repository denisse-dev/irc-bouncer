#!/bin/bash

GOOGLE_AUTHENTICATOR='auth     required  pam_google_authenticator.so'
DISABLE_PASSWORD='auth      include   system-remote-login'
SSHD_CONFIG=(
    '#PermitRootLogin yes/PermitRootLogin no'
    '#ClientAliveInterval 0/ClientAliveInterval 300'
    '#ClientAliveCountMax 3/ClientAliveCountMax 2'
    '#Port 22/Port 65432'
    '#MaxAuthTries 6/MaxAuthTries 3'
    'X11Forwarding yes/X11Forwarding no'
    'ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes'
)
PAM_CONFIG=(
    "s/${DISABLE_PASSWORD}/${GOOGLE_AUTHENTICATOR}\n#${DISABLE_PASSWORD}/g"
    's/#auth     required  pam_securetty.so/auth      required  pam_securetty.so/g'
)

function sedIterator() {
    local LOCATION="$1"
    shift
    local CONFIG=("$@")
    for i in "${CONFIG[@]}";
    do
        sed -i 's/'"$i"'/g' "$LOCATION"
    done
}

function harden_sshd() {
    echo 'AuthenticationMethods publickey,keyboard-interactive:pam' >> /etc/ssh/sshd_config
    sedIterator "/etc/pam.d/sshd" "${PAM_CONFIG[@]}"
    sedIterator "/etc/ssh/sshd_config" "${SSHD_CONFIG[@]}"
    sudo -u bouncie -- sh -c "yes | google-authenticator"
    systemctl reload sshd
    systemctl restart sshd
}

function configure_firewall() {
    firewall-cmd --permanent --add-port=65432/tcp
    firewall-cmd --permanent --add-port=6697/tcp
    firewall-cmd --reload
    systemctl start firewalld
    systemctl enable firewalld
}

harden_sshd
configure_firewall
