#!/bin/bash

function check_is_root () {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or with sudo"
        exit
    fi
    return 0
}


TIMESTAMP=$(date '+%Y%m%d')
ISO_NAME="ubuntu-from-scratch-${TIMESTAMP}.iso"
LIVECD_DIR_NAME=live-ubuntu-from-scratch
LIVECD_HOME_DIR=$HOME/$LIVECD_DIR_NAME