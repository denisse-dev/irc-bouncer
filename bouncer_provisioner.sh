#!/bin/bash

PROXYCHAINS_VER=4.14
ZNC_OVERRIDE="[Service]
ExecStart=
ExecStart=/usr/local/bin/proxychains4 /usr/bin/znc -f
User=znc"

function install_packages() {
    sudo yum update -y
    sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
    sudo yum install znc znc-devel tor torsocks emacs firewalld tmux curl deltarpm -y
    sudo yum group install "Development Tools" -y
}

function install_proxychains() {
    local URL=https://github.com/rofl0r/proxychains-ng/archive/v${PROXYCHAINS_VER}.zip
    local FILE=proxychains-ng.zip
    local DIR=proxychains-ng
    curl -L0k "$URL" -o "$FILE"
    unzip "$FILE"
    cd proxychains-ng-${PROXYCHAINS_VER} || return
    sudo ./configure
    sudo make && sudo make install
    sudo make install-config
    cd - || return
    rm -rf "$FILE" "$DIR"
}

function configure_proxychains() {
    echo 'mapaddress 10.99.99.90 freenodeok2gncmy.onion' | sudo tee -a /etc/tor/torrc
    sudo systemctl daemon-reload
    sudo systemctl restart tor
    sudo mkdir -p /etc/systemd/system/znc.service.d/
    sudo systemctl enable znc.service
    echo "$ZNC_OVERRIDE" | sudo tee -a /etc/systemd/system/znc.service.d/override.conf
    sudo systemctl daemon-reload
    sudo systemctl restart znc
}

function configure_timezone() {
    echo 'ZONE="America/Chicago"' | sudo tee -a /etc/sysconfig/clock
    sudo ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
}

function configure_firewall() {
    sudo firewall-cmd --permanent --add-service=ssh
    sudo firewall-cmd --permanent --add-port=6697/tcp
    sudo firewall-cmd --reload
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
}

function install_znc_clientbuffer() {
    local URL=https://github.com/CyberShadow/znc-clientbuffer/archive/master.zip
    local FILE=znc-clientbuffer.zip
    local DIR=znc-clientbuffer-master
    curl -L0k "$URL" -o "$FILE"
    unzip "$FILE"
    cd "$DIR" || return
    znc-buildmod clientbuffer.cpp
    sudo chown znc:znc clientbuffer.so
    sudo mv clientbuffer.so /usr/lib64/znc/
    sudo systemctl restart znc
    cd - || return
    rm -rf "$DIR" "$FILE"
}

install_packages
install_proxychains
configure_proxychains
configure_timezone
configure_firewall
install_znc_clientbuffer
