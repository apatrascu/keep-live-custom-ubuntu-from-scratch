#!/bin/bash

apt-get -y install \
    brasero \
    build-essential \
    curl \
    libssl-dev \
    openssh-server \
    python \
    python-pip \
    python-dev \
    python3 \
    python3-pip \
    python3-dev \
    python3-virtualenv \
    screen \
    smplayer \
    sshpass \
    sudo \
    tree \
    zip \
    vim \
    vlc \
    wget

# Font
add-apt-repository universe
apt-get update
apt install fonts-firacode
