#!/bin/bash

SSHD_CONFIG_REPLACE=(
    '#Port 22=Port 45632'
    '#PermitRootLogin yes=PermitRootLogin no'
    '#ClientAliveInterval 0=ClientAliveInterval 300'
    '#ClientAliveCountMax 3=ClientAliveCountMax 2'
    '#MaxAuthTries 6=MaxAuthTries 3'
    'X11Forwarding yes=X11Forwarding no'
    'HostKey /etc/ssh/ssh_host_rsa_key=#HostKey /etc/ssh/ssh_host_rsa_key'
    'HostKey /etc/ssh/ssh_host_ecdsa_key=#HostKey /etc/ssh/ssh_host_rsa_key'
    '#LogLevel INFO=LogLevel VERBOSE'
    'Subsystem       sftp    /usr/libexec/openssh/sftp-server=Subsystem sftp /usr/lib/ssh/sftp-server -f AUTHPRIV -l INFO'
)
SSHD_CONFIG_APPEND=(
    'AuthenticationMethods publickey'
    'AllowUsers bouncie'
    'DenyUsers root'
    'Banner /etc/ssh/banner'
    'PrintLastLog yes'
    'HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-ed25519'
    'KexAlgorithms curve25519-sha256'
    'Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com'
    'MACs hmac-sha2-512,hmac-sha2-512-etm@openssh.com'
)
SSHD_DIRECTORY='/etc/ssh/sshd_config'
FAIL2BAN_CONFIG_REPLACE=(
    'backend = auto/backend = systemd'
    'banaction = iptables-multiport/banaction = firewallcmd-ipset'
    'banaction_allports = iptables-allports/banaction_allports = firewallcmd-ipset'
)
FAIL2BAN_OVERRIDE='[Service]
PrivateDevices=yes
PrivateTmp=yes
ProtectHome=read-only
ProtectSystem=strict
NoNewPrivileges=yes
ReadWritePaths=-/var/run/fail2ban
ReadWritePaths=-/var/lib/fail2ban
ReadWritePaths=-/var/log/fail2ban
ReadWritePaths=-/var/spool/postfix/maildrop
CapabilityBoundingSet=CAP_AUDIT_READ CAP_DAC_READ_SEARCH'
FAIL2BAN_CONFIG_SSHD='[ssh]

enabled  = true
port     = 45632
filter   = sshd
logpath  = /var/log/auth.log
findtime = 1d
bantime  = 2w
maxretry = 3'

function configure_sshd() {
    for i in "${SSHD_CONFIG_REPLACE[@]}"; do
        sed -i 's='"$i"'=g' "$SSHD_DIRECTORY"
    done
    for i in "${SSHD_CONFIG_APPEND[@]}"; do
        echo "$i" >> "$SSHD_DIRECTORY"
    done
    systemctl reload sshd
    systemctl restart sshd
}

function configure_firewall() {
    systemctl start firewalld
    firewall-cmd --zone=public --permanent --add-port=45632/tcp
    firewall-cmd --zone=public --permanent --add-port=6697/tcp
    firewall-cmd --reload
    systemctl enable firewalld
}

function configure_fail2ban() {
    local FAIL2BAN_JAIL='/etc/fail2ban/jail.local'
    cp /etc/fail2ban/jail.conf "$FAIL2BAN_JAIL"
    for i in "${FAIL2BAN_CONFIG_REPLACE[@]}"; do
        sed -i 's/'"$i"'/g' "$FAIL2BAN_JAIL"
    done
    echo "$FAIL2BAN_CONFIG_SSHD" >> /etc/fail2ban/jail.d/sshd.local
    mdkir -p /etc/systemd/system/fail2ban.service.d
    echo "$FAIL2BAN_OVERRIDE" >> /etc/systemd/system/fail2ban.service.d/override.conf
    systemctl reload fail2ban
    systemctl start fail2ban
    systemctl enable fail2ban
}

function disable_root_user() {
    sed -i 's=root:x:0:0:root:/root:/bin/bash=root:x:0:0:root:/root:/sbin/nologin=g' /etc/passwd
}

configure_sshd
configure_firewall
configure_fail2ban
disable_root_user
