#!/bin/bash

PROXYCHAINS_VER=4.14
PROXYCHAINS_URL=https://github.com/rofl0r/proxychains-ng/archive/v${PROXYCHAINS_VER}.zip
ZNC_CLIENTBUFFER_URL=https://github.com/CyberShadow/znc-clientbuffer/archive/master.zip
PROXYCHAINS_HASH='261c26ae942f3f70d0e058ebc9b7e862062a0357fb96483908a8ef925698b4d76c5e1231f7fc3c51c9c6a16bb5831054e9fef72da68f47cb3ed0c80ebc1fc6cb  proxychains-ng.zip'
ZNC_OVERRIDE="[Service]
ExecStart=
ExecStart=/usr/local/bin/proxychains4 /usr/bin/znc -f
User=znc"

function install_packages() {
    yum update -y > /dev/null
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y > /dev/null
    yum install znc znc-devel tor torsocks emacs-nox firewalld tmux curl deltarpm google-authenticator qrencode iproute fail2ban -y > /dev/null
    yum group install "Development Tools" -y > /dev/null
}

function install_proxychains() {
    local FILE=proxychains-ng.zip
    local DIR=proxychains-ng
    curl -L0k "$PROXYCHAINS_URL" -o "$FILE" > /dev/null
    if [[ "$PROXYCHAINS_HASH" != "$(sha512sum $FILE)" ]]; then
        exit 1
    fi
    unzip "$FILE" > /dev/null
    cd proxychains-ng-${PROXYCHAINS_VER} || return
    ./configure > /dev/null
    make && make install > /dev/null
    make install-config > /dev/null
    cd - || return
    rm -rf "$FILE" "$DIR"
}

function configure_proxychains() {
    echo 'mapaddress 10.99.99.90 freenodeok2gncmy.onion' | tee -a /etc/tor/torrc
    systemctl daemon-reload > /dev/null
    systemctl restart tor > /dev/null
    mkdir -p /etc/systemd/system/znc.service.d/
    systemctl enable znc.service > /dev/null
    echo "$ZNC_OVERRIDE" | tee -a /etc/systemd/system/znc.service.d/override.conf
    systemctl daemon-reload > /dev/null
    systemctl restart znc > /dev/null
}

function configure_timezone() {
    echo 'ZONE="America/Chicago"' | tee -a /etc/sysconfig/clock
    ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
}

function install_znc_clientbuffer() {
    local FILE=znc-clientbuffer.zip
    local DIR=znc-clientbuffer-master
    curl -L0k "$ZNC_CLIENTBUFFER_URL" -o "$FILE" > /dev/null
    unzip "$FILE"
    cd "$DIR" || return
    znc-buildmod clientbuffer.cpp > /dev/null
    chown znc:znc clientbuffer.so > /dev/null
    mv clientbuffer.so /usr/lib64/znc/
    systemctl restart znc > /dev/null
    cd - || return
    rm -rf "$DIR" "$FILE"
}

install_packages
install_proxychains
configure_proxychains
configure_timezone
install_znc_clientbuffer
