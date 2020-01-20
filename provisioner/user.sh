#!/bin/bash

USER_NAME='bouncie'

function createUser() {
    adduser -m "$USER_NAME" > /dev/null
    echo "bouncie  ALL=(ALL)   ALL" > /etc/sudoers.d/"$USER_NAME"

    sudo -u "$USER_NAME" -- sh -c "
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    curl https://github.com/da-edra.keys -o ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys"

    passwd -d "$USER_NAME" > /dev/null
    passwd -e "$USER_NAME" > /dev/null
}

createUser
