#!/bin/bash

SSH_CONFIG='/etc/ssh/sshd_config'
PAM_SSH='/etc/pam.d/sshd'

function enable_totp() {
    sed -i 's/AuthenticationMethods publickey/AuthenticationMethods publickey keyboard-interactive:pam/g' "$SSH_CONFIG"
    sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' "$SSH_CONFIG"
    echo "UsePAM yes" >> "$SSH_CONFIG"
    echo -e "auth required pam_google_authenticator.so\n$(cat /etc/pam.d/sshd)" > "$PAM_SSH"
    sed -i 's/auth      include   system-remote-login/#auth      include   system-remote-login/g' "$PAM_SSH"
    systemctl reload sshd
    systemctl restart sshd
    google-authenticator
}

enable_totp
