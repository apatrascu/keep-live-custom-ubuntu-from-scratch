#!/bin/bash

function check_is_root () {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or with sudo"
        exit
    fi
    return 0
}
