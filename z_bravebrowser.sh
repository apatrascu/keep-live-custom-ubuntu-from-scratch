#!/bin/bash

apt install apt-transport-https curl -y
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
apt update
apt install -y brave-browser
