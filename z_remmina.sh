#!/bin/bash

# Remmina
add-apt-repository -y ppa:remmina-ppa-team/remmina-next
apt update
apt install -y remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice
