#!/bin/bash

GOOGLE_AUTHENTICATOR='auth     required  pam_google_authenticator.so'
DISABLE_PASSWORD='auth      include   system-remote-login'
SSHD_CONFIG=(
    'ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes'
)
PAM_CONFIG=(
    "${DISABLE_PASSWORD}/${GOOGLE_AUTHENTICATOR}\n#${DISABLE_PASSWORD}"
    '#auth     required  pam_securetty.so/auth      required  pam_securetty.so'
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

function enable_totp() {
    sedIterator "/etc/pam.d/sshd" "${PAM_CONFIG[@]}"
    sedIterator "/etc/ssh/sshd_config" "${SSHD_CONFIG[@]}"
    echo 'Authentication Methods publickey,keyboard-interactive:pam' >> /etc/ssh/sshd_config
    systemctl reload sshd
    systemctl restart sshd
}

enable_totp
